//
//  CityVM.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation
import CoreLocation

final class CityVM: TemperatureScaleConversionDataSource, DateTimeDataSource {
    private(set) lazy var cityForecast = Bindable<[CityForecastWeatherDataCVCModel]>()
    private(set) lazy var cityCondition = Bindable<[CityConditionWeatherDataCVCModel]>()
    private(set) lazy var error = Bindable<NetworkError>()
    private var cityData: CityTVCModel?
    private var temperatureScale: TemperatureScale = .celsius
    private var cdCityManager = CDCityManager()
    private let apiService: APIServiceProvider
    
    init(apiService: APIServiceProvider = APIService()) {
        self.apiService = apiService
    }
}

extension CityVM {
    
    final func getOfflineData() {
        offlineWeatherData()
    }
    
    final func setTemperatureScale(_ scale: TemperatureScale) {
        self.temperatureScale = scale
    }
    
    final func setCityData(_ city: CityTVCModel) {
        self.cityData = city
    }
}

//handling weather API
extension CityVM {
    
    final func fireAPIGETWeatherForecast(for location: CLLocation, onCompletion: (() -> ())? = nil) {
        getWeatherForecast(for: location) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                if let cityWeatherList = forecast.list {
                    self.weatherForecastOperation(for: cityWeatherList, onCompletion: onCompletion)
                }
            case .failure(let error):
                self.error.value = error
                self.offlineWeatherData()
            }
        }
    }
    
    private func offlineWeatherData() {
        if let cityData = self.cityData {
            self.cdCityManager.get(byIdentifier: cityData.id) { city in
                if city?.scale != self.temperatureScale.rawValue {
                    if let city = city {
                        self.offlineWeatherOperationOnTemperatureScaleModifiation(for: city)
                    }
                } else {
                    self.cityCondition.value = city?.condition?.sorted { $0.title < $1.title }
                    self.cityForecast.value = city?.forecast?.sorted { $0.dt < $1.dt }
                }
            }
        }
    }
    
    private func offlineWeatherOperationOnTemperatureScaleModifiation(for city: CityTVCModel) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            var tempCityForecast = city.forecast
            var tempCityCondition = city.condition
            
            if let cityForecastList = city.forecast,
               cityForecastList.count > 0 {
                for index in 0..<cityForecastList.count {
                    var cityForecast = cityForecastList[index]
                    cityForecast.temperatureHigh = self.temperatureScale == .celsius ? (city.scale == "" ? cityForecast.temperatureHigh : self.convertFahrenheitToCelsius(cityForecast.temperatureHigh)) : self.convertCelsiusToFahrenheit(cityForecast.temperatureHigh)
                    cityForecast.temperatureLow = self.temperatureScale == .celsius ? (city.scale == "" ? cityForecast.temperatureLow : self.convertFahrenheitToCelsius(cityForecast.temperatureLow)) : self.convertCelsiusToFahrenheit(cityForecast.temperatureLow)
                    tempCityForecast?[index] = cityForecast
                    if index == cityForecastList.count - 1 {
                        self.cityData?.forecast = tempCityForecast
                        if let cityData = self.cityData {
                            self.cdCityManager.update(record: cityData) { (isCityRecordUpdated) in
                                if isCityRecordUpdated {
                                    self.cityForecast.value = tempCityForecast?.sorted { $0.dt < $1.dt }
                                }
                            }
                        }
                    }
                }
            }
            
            if let cityCondition = city.condition,
               cityCondition.count > 0 {
                for index in 0..<cityCondition.count where city.condition?[index].title == WeatherCondition.feelsLike.title {
                    guard let value = Double(city.condition?[index].message ?? "") else { return }
                    let temperatureScaleValue: String = "\(Int(self.temperatureScale == .celsius ? (city.scale == "" ? value : self.convertFahrenheitToCelsius(value)) : self.convertCelsiusToFahrenheit(value)))"
                    tempCityCondition?[index].message = temperatureScaleValue
                    self.cityData?.condition = tempCityCondition
                    self.cityData?.scale = self.temperatureScale.rawValue
                    if let cityData = self.cityData {
                        self.cdCityManager.update(record: cityData) { (isCityRecordUpdated) in
                            if isCityRecordUpdated {
                                self.cityCondition.value = tempCityCondition?.sorted { $0.title < $1.title }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func weatherForecastOperation(for cityWeatherList: [CityWeatherForecastResponse.CityWeather], onCompletion: (() -> ())? = nil) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            var tempCityForecast = [CityForecastWeatherDataCVCModel]()
            var tempCityCondition = [CityConditionWeatherDataCVCModel]()
            for index in 0..<cityWeatherList.count {
                let temperatureHighInCelcius = self.convertKelvinToCelsius(cityWeatherList[index].main.tempMax)
                let temperatureLowInCelcius = self.convertKelvinToCelsius(cityWeatherList[index].main.tempMin)
                let icon = BaseUrl.icon.rawValue + EndPoints.icon.rawValue + (cityWeatherList[index].weather?.first?.icon ?? "") + ImageType.png.rawValue
                let cityForecast = CityForecastWeatherDataCVCModel(id: cityWeatherList[index].dt,
                                                                   dt: (cityWeatherList.first?.dt ?? 0) + (index * 24 * 3600),
                                                                   day: index == 0 ? "CityVM.Day.Today.Title".localized : self.toWeekday(from: (cityWeatherList.first?.dt ?? 0) + (index * 24 * 3600)),
                                                                   icon: icon,
                                                                   temperatureHigh: self.temperatureScale == .celsius ? temperatureHighInCelcius : self.convertCelsiusToFahrenheit(temperatureHighInCelcius),
                                                                   temperatureLow: self.temperatureScale == .celsius ? temperatureLowInCelcius : self.convertCelsiusToFahrenheit(temperatureLowInCelcius))
                tempCityForecast.append(cityForecast)
                
                if index == 0 {
                    let condtionDict: [String: Any?] = cityWeatherList.first?.main.asDictionary ?? [:]
                    for (key, value) in condtionDict {
                        if let condition = WeatherCondition(rawValue: key) {
                            if condition == .feelsLike {
                                if let value = value as? Double {
                                    let feelsLikeInCelcius = self.convertKelvinToCelsius(value)
                                    let temperatureScaleValue: String = "\(Int(self.temperatureScale == .celsius ? feelsLikeInCelcius : self.convertCelsiusToFahrenheit(feelsLikeInCelcius)))"
                                    tempCityCondition.append(CityConditionWeatherDataCVCModel(id: (cityWeatherList.first?.dt ?? 0), title: condition.title, message: temperatureScaleValue))
                                }
                            } else {
                                tempCityCondition.append(CityConditionWeatherDataCVCModel(id: (cityWeatherList.first?.dt ?? 0), title: condition.title, message: "\(String(describing: value ?? ""))"))
                            }
                        }
                    }
                }
                
                if index == cityWeatherList.count - 1 {
                    self.cityData?.scale = self.temperatureScale.rawValue
                    self.cityData?.condition = tempCityCondition
                    self.cityData?.forecast = tempCityForecast
                    if let cityData = self.cityData {
                        self.cdCityManager.update(record: cityData) { (isCityRecordUpdated) in
                            if isCityRecordUpdated {
                                self.cityCondition.value = tempCityCondition.sorted { $0.title < $1.title }
                                tempCityCondition = []
                                self.cityForecast.value = tempCityForecast.sorted { $0.dt < $1.dt }
                                tempCityForecast = []
                                onCompletion?()
                            }
                        }
                    } else {
                        print(tempCityCondition)
                        print(tempCityForecast)
                        self.cityCondition.value = tempCityCondition.sorted { $0.title < $1.title }
                        tempCityCondition = []
                        self.cityForecast.value = tempCityForecast.sorted { $0.dt < $1.dt }
                        tempCityForecast = []
                        onCompletion?()
                    }
                }
            }
        }
    }
    
    private func getWeatherForecast(for location: CLLocation, onCompletion: @escaping (Result<CityWeatherForecastResponse, NetworkError>) -> Void) {
        apiService.request(with: GETWeatherForecastDataURN(location: location, count: 7), onCompletion: onCompletion)
    }
}

//testing
extension CityVM {
    func testCityForecast(for model: CityForecastWeatherDataCVCModel) {
        self.cityForecast.value = [model]
    }
    
    func testCityCondition(for model: [CityConditionWeatherDataCVCModel]) {
        self.cityCondition.value = model
    }
}

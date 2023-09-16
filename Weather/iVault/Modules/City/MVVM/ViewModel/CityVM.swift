//
//  CityVM.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation
import CoreLocation

class CityVM: APIServiceProvider, TemperatureScaleConversionDataSource, DateTimeDataSource {
    private(set) lazy var cityForecast = Bindable<[CityForecastWeatherDataCVCModel]>()
    private(set) lazy var cityCondition = Bindable<[CityConditionWeatherDataCVCModel]>()
    private(set) lazy var error = Bindable<NetworkError>()
    private(set) var temperatureScale: TemperatureScale = .celsius
    private(set) var cityData: CityTVCModel?
    private var cdCityManager = CDCityManager()
}

extension CityVM {
    func setTemperatureScale(_ scale: TemperatureScale) {
        self.temperatureScale = scale
    }
    
    func setCityData(_ city: CityTVCModel) {
        self.cityData = city
    }
}

//handling weather API
extension CityVM {
    
    final func fireAPIGETWeatherForecast(for location: CLLocation) {
        getWeatherForecast(for: location){ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                print(forecast)
                DispatchQueue.global(qos: .userInteractive).async {
                    if let cityWeatherList = forecast.list {
                        var tempCityForecast = [CityForecastWeatherDataCVCModel]()
                        var tempCityCondition = [CityConditionWeatherDataCVCModel]()
                        for index in 0..<cityWeatherList.count {
                            let temperatureHighInCelcius = self.convertKelvinToCelsius(cityWeatherList[index].main.tempMax)
                            let temperatureLowInCelcius = self.convertKelvinToCelsius(cityWeatherList[index].main.tempMin)
                            let icon = BaseUrl.icon.rawValue + EndPoints.icon.rawValue + (cityWeatherList[index].weather?.first?.icon ?? "") + ImageType.png.rawValue
                            let cityForecast = CityForecastWeatherDataCVCModel(id: cityWeatherList[index].dt,
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
                                self.cityData?.condition = tempCityCondition
                                self.cityData?.forecast = tempCityForecast
                                if let cityData = self.cityData {
                                    self.cdCityManager.update(record: cityData) { [weak self] (isCityRecordUpdated) in
                                        guard let self = self else { return }
                                        if isCityRecordUpdated {
                                            self.cityCondition.value = tempCityCondition
                                            tempCityCondition = []
                                            self.cityForecast.value = tempCityForecast
                                            tempCityForecast = []
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                self.error.value = error
                if let cityData = self.cityData {
                    self.cdCityManager.get(byIdentifier: cityData.id) { city in
                        self.cityCondition.value = city?.condition
                        self.cityForecast.value = city?.forecast
                    }
                }
            }
        }
    }
    
    private func getWeatherForecast(for location: CLLocation, onCompletion: @escaping (Result<CityWeatherForecastResponse, NetworkError>) -> Void) {
        request(with: GETWeatherForecastDataURN(location: location, count: 7), onCompletion: onCompletion)
    }
}

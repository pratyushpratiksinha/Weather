//
//  CityListVM.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation
import CoreLocation

final class CityListVM: TemperatureScaleConversionDataSource {
    private(set) lazy var cityList = Bindable<[CityTVCModel]>()
    private(set) lazy var availableObjCity = Bindable<CityTVCModel>()
    private(set) lazy var alert = Bindable<(String, String)>()
    private(set) lazy var error = Bindable<NetworkError>()
    private(set) var temperatureScale: TemperatureScale = .celsius
    private var cdCityManager = CDCityManager()
    private let apiService: APIServiceProvider
    
    init(apiService: APIServiceProvider = APIService()) {
        self.apiService = apiService
    }
}

extension CityListVM {
    
    final func setTemperatureScaleInUserDefaults(_ scale: TemperatureScale) {
        UserDefaults.temperatureScale = scale.rawValue
        temperatureScale = scale
    }
    
    final func getTemperatureScaleFromUserDefaults() -> TemperatureScale? {
        if let scale = TemperatureScale(rawValue: UserDefaults.temperatureScale ?? "") {
            return scale
        } else {
            return nil
        }
    }
    
    final func getCDCityListRecords(onCompletion: @escaping (Bool) -> Void)  {
        if let cityListRecords = cdCityManager.getAll(),
           cityListRecords.count > 0 {
            onCompletion(true)
            if NetworkReachabilityManager()?.isReachable == true {
                updateDataForDBData(cityListRecords)
            } else {
                cityList.value = cityListRecords
            }
        } else {
            onCompletion(false)
        }
    }
    
    final func deleteElement(fromCityListAt index: Int) {
        cdCityManager.delete(byIdentifier: self.cityList.value?[index].id ?? 0) { [weak self] (isCityRecordDeleted) in
            guard let self = self else { return }
            if isCityRecordDeleted {
                self.cityList.value?.remove(at: index)
            }
        }
    }
    
    final func displayConvertedTemperature(temperatureScale: TemperatureScale) {
        self.temperatureScale = temperatureScale
        var tempCityListValue = cdCityManager.getAll() ?? []
        for index in 0..<tempCityListValue.count {
            tempCityListValue[index].temperatureCurrent = temperatureScale == .fahrenheit ? convertCelsiusToFahrenheit(tempCityListValue[index].temperatureCurrent) : convertFahrenheitToCelsius(tempCityListValue[index].temperatureCurrent)
            tempCityListValue[index].temperatureHigh = temperatureScale == .fahrenheit ? convertCelsiusToFahrenheit(tempCityListValue[index].temperatureHigh) : convertFahrenheitToCelsius(tempCityListValue[index].temperatureHigh)
            tempCityListValue[index].temperatureLow = temperatureScale == .fahrenheit ? convertCelsiusToFahrenheit(tempCityListValue[index].temperatureLow) : convertFahrenheitToCelsius(tempCityListValue[index].temperatureLow)
            if index == tempCityListValue.count - 1 {
                cdCityManager.update(records: tempCityListValue) { [weak self] (isCityRecordUpdated) in
                    guard let self = self else { return }
                    if isCityRecordUpdated {
                        self.cityList.value = self.cdCityManager.getAll()?.sorted { ($0.index ?? 0) < ($1.index ?? 0) }
                    }
                }
            }
        }
    }
    
    final func updateDataForDBData(_ cityList: [CityTVCModel]) {
        self.temperatureScale = getTemperatureScaleFromUserDefaults() ?? .celsius
        for index in 0..<cityList.count {
            fireAPIUpdateWeatherForDBData(for: cityList[index].id, location: cityList[index].location) {
                if index == cityList.count - 1 {
                    self.cityList.value = self.cdCityManager.getAll()?.sorted { ($0.index ?? 0) < ($1.index ?? 0) }
                }
            }
        }
    }
}

//handling weather API
extension CityListVM {
    
    final func fireAPIGETWeather(for location: CLLocation, onCompletion: (() -> ())? = nil) {
        getWeather(for: location){ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let city):
                DispatchQueue.global(qos: .userInteractive).async {
                    let temperatureCurrentInCelcius = self.convertKelvinToCelsius(city.main.temp)
                    let temperatureHighInCelcius = self.convertKelvinToCelsius(city.main.tempMax)
                    let temperatureLowInCelcius = self.convertKelvinToCelsius(city.main.tempMin)
                    var backgroundImage: String?
                    
                    if (city.dt ?? 0) > (city.sys.sunrise ?? 0) && (city.dt ?? 0) < (city.sys.sunset ?? 0) {
                        backgroundImage = WeatherDescription(rawValue: city.weather?.first?.description ?? "")?.dayImage
                    } else {
                        backgroundImage = WeatherDescription(rawValue: city.weather?.first?.description ?? "")?.nightImage
                    }
                    
                    let element = CityTVCModel(id: city.id,
                                               cityName: city.name,
                                               countryName: city.sys.country,
                                               weatherDescription: city.weather?.first?.description ?? "",
                                               backgroundImage: backgroundImage,
                                               temperatureCurrent: self.temperatureScale == .celsius ? temperatureCurrentInCelcius : self.convertCelsiusToFahrenheit(temperatureCurrentInCelcius),
                                               temperatureHigh: self.temperatureScale == .celsius ? temperatureHighInCelcius : self.convertCelsiusToFahrenheit(temperatureHighInCelcius),
                                               temperatureLow: self.temperatureScale == .celsius ? temperatureLowInCelcius : self.convertCelsiusToFahrenheit(temperatureLowInCelcius),
                                               location: CLLocation(latitude: city.coord.lat, longitude: city.coord.lon),
                                               scale: self.temperatureScale.rawValue)
                    if self.cityList.value == nil {
                        self.cdCityManager.create(record: element) { isCreatedCityRecord in
                            if isCreatedCityRecord {
                                self.cityList.value = self.cdCityManager.getAll()
                                onCompletion?()
                            }
                        }
                    } else {
                        if let obj = self.cityList.value?.first(where: {$0.id == element.id}) {
                            self.availableObjCity.value = obj
                        } else {
                            self.cdCityManager.create(record: element) { isCreatedCityRecord in
                                if isCreatedCityRecord {
                                    self.cityList.value?.append(element)
                                    onCompletion?()
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                self.error.value = error
                self.alert.value = ("CityListVM.Alert.Faliure.Title".localized,
                                        error.description)
            }
        }
    }
    
    final func fireAPIUpdateWeatherForDBData(for id: Int, location: CLLocation, onCompletion: @escaping () -> ()) {
        cdCityManager.get(byIdentifier: id) { [weak self] (cdCity) in
            guard let self = self else { return }
            self.getWeather(for: location) { (result) in
                switch result {
                case .success(let city):
                    DispatchQueue.global(qos: .userInteractive).async {
                        let temperatureCurrentInCelcius = self.convertKelvinToCelsius(city.main.temp)
                        let temperatureHighInCelcius = self.convertKelvinToCelsius(city.main.tempMax)
                        let temperatureLowInCelcius = self.convertKelvinToCelsius(city.main.tempMin)
                        var backgroundImage: String?
                        
                        if (city.dt ?? 0) > (city.sys.sunrise ?? 0) && (city.dt ?? 0) < (city.sys.sunset ?? 0) {
                            backgroundImage = WeatherDescription(rawValue: city.weather?.first?.description ?? "")?.dayImage
                        } else {
                            backgroundImage = WeatherDescription(rawValue: city.weather?.first?.description ?? "")?.nightImage
                        }
                        
                        if let cdCity = cdCity {
                            var element = cdCity
                            element.weatherDescription = city.weather?.first?.description ?? ""
                            element.backgroundImage = backgroundImage
                            element.temperatureCurrent = self.temperatureScale == .celsius ? temperatureCurrentInCelcius : self.convertCelsiusToFahrenheit(temperatureCurrentInCelcius)
                            element.temperatureHigh = self.temperatureScale == .celsius ? temperatureHighInCelcius : self.convertCelsiusToFahrenheit(temperatureHighInCelcius)
                            element.temperatureLow = self.temperatureScale == .celsius ? temperatureLowInCelcius : self.convertCelsiusToFahrenheit(temperatureLowInCelcius)
                            
                            self.cdCityManager.update(record: element) { isUpdatedCityRecord in
                                if isUpdatedCityRecord {
                                    onCompletion()
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self.error.value = error
                }
            }
        }
        
    }
    
    private func getWeather(for location: CLLocation, onCompletion: @escaping (Result<CityWeatherResponse, NetworkError>) -> Void) {
        apiService.request(with: GETWeatherDataURN(location: location), onCompletion: onCompletion)
    }
}

//handling geo API
extension CityListVM {
    
    final func fireAPIGETGeo(from zipCode: String) {
        getGeo(from: zipCode){ (result) in
            switch result {
            case .success(let geo):
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else { return }
                    self.fireAPIGETWeather(for: CLLocation(latitude: geo.lat, longitude: geo.lon))
                }
            case .failure(let error):
                self.error.value = error
                if error == .customError(error: "Error Status Code = 404") {
                    self.alert.value = ("CityListVM.Alert.Faliure.Title".localized,
                                        "CityListVM.Alert.ZipcodeNotAvailable.Message".localized)
                } else {
                    self.alert.value = ("CityListVM.Alert.Faliure.Title".localized,
                                        error.description)
                }
            }
        }
    }
    
    private func getGeo(from zipCode: String, onCompletion: @escaping (Result<GeoResponse, NetworkError>) -> Void) {
        apiService.request(with: GETGeoDataURN(zip: zipCode), onCompletion: onCompletion)
    }
}

extension CityListVM {
    final func optionItemList(didSelectOptionItem item: PopoverOptionItem, onCompletion: (ElementOperation) -> Void) {
        if let item = item as? TemperatureScaleOptionItem {
            switch item.text {
            case "CityVC.Popover.FahrenheitItem.Title".localized:
                if temperatureScale == .fahrenheit {
                    return
                } else {
                    setTemperatureScaleInUserDefaults(.fahrenheit)
                    onCompletion(.updated)
                    displayConvertedTemperature(temperatureScale: .fahrenheit)
                }
            case "CityVC.Popover.CelsiusItem.Title".localized:
                if temperatureScale == .celsius {
                    return
                } else {
                    setTemperatureScaleInUserDefaults(.celsius)
                    onCompletion(.updated)
                    displayConvertedTemperature(temperatureScale: .celsius)
                }
            default:
                return
            }
        }
    }
}

//testing
extension CityListVM {
    func testCityList(for model: CityTVCModel) {
        self.cityList.value = [model]
    }
}

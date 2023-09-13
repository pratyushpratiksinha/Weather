//
//  CityListVM.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation
import CoreLocation

class CityListVM: APIServiceProvider, TemperatureScaleConversionDataSource {
    private(set) lazy var cityList = Bindable<[CityTVCModel]>()
    private(set) var alert = Bindable<(String, String)>()
    private(set) var error = Bindable<NetworkError>()
    private(set) var temperatureScale: TemperatureScale = .celsius
}

extension CityListVM {
    final func deleteElement(fromCityListAt index: Int) {
        self.cityList.value?.remove(at: index)
    }
    
    final func displayConvertedTemperature(temperatureScale: TemperatureScale) {
        self.temperatureScale = temperatureScale
        var tempCityListValue = cityList.value ?? []
        if let value = cityList.value {
            for index in 0..<value.count {
                tempCityListValue[index].temperatureCurrent = temperatureScale == .fahrenheit ? convertCelsiusToFahrenheit(tempCityListValue[index].temperatureCurrent) : convertFahrenheitToCelsius(tempCityListValue[index].temperatureCurrent)
                tempCityListValue[index].temperatureHigh = temperatureScale == .fahrenheit ? convertCelsiusToFahrenheit(tempCityListValue[index].temperatureHigh) : convertFahrenheitToCelsius(tempCityListValue[index].temperatureHigh)
                tempCityListValue[index].temperatureLow = temperatureScale == .fahrenheit ? convertCelsiusToFahrenheit(tempCityListValue[index].temperatureLow) : convertFahrenheitToCelsius(tempCityListValue[index].temperatureLow)
                if index == value.count - 1 {
                    cityList.value = tempCityListValue
                }
            }
        }
    }
}

//handling weather API
extension CityListVM {
    
    final func fireAPIGETWeather(for location: CLLocation) {
        getWeather(for: location){ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let city):
                print(city)
                DispatchQueue.global(qos: .userInteractive).async {
                    let temperatureCurrentInCelcius = self.convertKelvinToCelsius(city.main.temp)
                    let temperatureHighInCelcius = self.convertKelvinToCelsius(city.main.tempMax)
                    let temperatureLowInCelcius = self.convertKelvinToCelsius(city.main.tempMin)
                    let element = CityTVCModel(id: city.id,
                                               cityName: city.name,
                                               countryName: city.sys.country,
                                               weatherDescription: city.weather?[0].description ?? "",
                                               temperatureCurrent: self.temperatureScale == .celsius ? temperatureCurrentInCelcius : self.convertCelsiusToFahrenheit(temperatureCurrentInCelcius),
                                               temperatureHigh: self.temperatureScale == .celsius ? temperatureHighInCelcius : self.convertCelsiusToFahrenheit(temperatureHighInCelcius),
                                               temperatureLow: self.temperatureScale == .celsius ? temperatureLowInCelcius : self.convertCelsiusToFahrenheit(temperatureLowInCelcius))
                    if self.cityList.value == nil {
                        self.cityList.value = [element]
                    } else {
                        if self.cityList.value?.contains(where: {$0.id == element.id}) ?? false {
                            self.alert.value = ("CityListVM.Alert.CityAlreadyAvailable.Title".localized,
                                                "CityListVM.Alert.CityAlreadyAvailable.Message".localized)
                        } else {
                            self.cityList.value?.append(element)
                        }
                    }
                }
            case .failure(let error):
                self.error.value = error
                if AppIngredients.isRelease == false {
                    self.alert.value = ("CityListVM.Alert.Faliure.Title".localized,
                                        error.localizedDescription)
                }
            }
        }
    }
    
    private func getWeather(for location: CLLocation, onCompletion: @escaping (Result<CityWeatherResponse, NetworkError>) -> Void) {
        request(with: GETWeatherDataURN(location: location), onCompletion: onCompletion)
    }
}

//handling geo API
extension CityListVM {
    
    final func fireAPIGETGeo(from zipCode: String) {
        getGeo(from: zipCode){ (result) in
            switch result {
            case .success(let geo):
                print(geo)
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else { return }
                    self.fireAPIGETWeather(for: CLLocation(latitude: geo.lat, longitude: geo.lon))
                }
            case .failure(let error):
                self.error.value = error
                self.alert.value = ("CityListVM.Alert.Faliure.Title".localized,
                                    "CityListVM.Alert.ZipcodeNotAvailable.Message".localized)
            }
        }
    }
    
    private func getGeo(from zipCode: String, onCompletion: @escaping (Result<GeoResponse, NetworkError>) -> Void) {
        request(with: GETGeoDataURN(zip: zipCode), onCompletion: onCompletion)
    }
}

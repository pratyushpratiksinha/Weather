//
//  CityListVM.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation
import CoreLocation

class CityListVM: APIServiceProvider {
        
    lazy var cityList = Bindable<[CityTVCModel]>()
    var alert = Bindable<(String, String)>()
    var error = Bindable<NetworkError>()
}

extension CityListVM {
    final func deleteElement(fromCityListAt index: Int) {
        self.cityList.value?.remove(at: index)
    }
}

//handling weather API
extension CityListVM {
    
    final func fireAPIGETWeather(for location: CLLocation) {
        getWeather(for: location){ (result) in
            switch result {
            case .success(let city):
                print(city)
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    guard let self = self else { return }
                    let element = CityTVCModel(id: city.id, cityName: city.name, countryName: city.sys.country, weatherDescription: city.weather[0].description ?? "", temperatureCurrent: city.main.temp, temperatureHigh: city.main.tempMax, temperatureLow: city.main.tempMin)
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

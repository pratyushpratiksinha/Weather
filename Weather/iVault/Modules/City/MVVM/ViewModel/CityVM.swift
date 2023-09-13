//
//  CityVM.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation
import CoreLocation

class CityVM: APIServiceProvider, TemperatureScaleConversionDataSource {
    private(set) lazy var cityForecast = Bindable<CityWeatherForecastResponse>()
    private(set) var error = Bindable<NetworkError>()
    private(set) var temperatureScale: TemperatureScale = .celsius
}

//handling weather API
extension CityVM {
    
    final func fireAPIGETWeatherForecast(for location: CLLocation) {
        getWeatherForecast(for: location){ [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let forecast):
                print(forecast)
                self.cityForecast.value = forecast
            case .failure(let error):
                self.error.value = error
            }
        }
    }
    
    private func getWeatherForecast(for location: CLLocation, onCompletion: @escaping (Result<CityWeatherForecastResponse, NetworkError>) -> Void) {
        request(with: GETWeatherForecastDataURN(location: location, count: 7), onCompletion: onCompletion)
    }
}

//
//  MockCityListAPIService.swift
//  WeatherTests
//
//  Created by Pratyush Pratik Sinha on 17/09/23.
//

import Foundation
@testable import Weather

final class MockCityListAPIServiceSuccess: APIServiceProvider {
    func request<T: URN>(with URN: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void) where T : URN {
        if let success = CityWeatherResponse(coord: .init(lon: 33.9731, lat: -118.24), weather: [.init(id: 1, main: "main", description: "description", icon: "icon")], base: "base", main: .init(temp: 34, tempMin: 20, tempMax: 56, feelsLike: 35, pressure: 1016, humidity: 86, seaLevel: 1016, grndLevel: 1009), visibility: 54, wind: .init(speed: 40, deg: 32, gust: 35), clouds: .init(all: 45), dt: 23, sys: .init(type: 43, id: 34, country: "India", sunrise: 345454, sunset: 345478), id: Int(UUID().hashValue), timezone: 23452354, name: UUID().uuidString, cod: 34) as? T.Derived {
            onCompletion(.success(success))
        }
    }
}

final class MockCityListAPIServiceError: APIServiceProvider {
    func request<T: URN>(with URN: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void) where T : URN {
        onCompletion(.failure(.customError(error: "Testing Error")))
    }
}

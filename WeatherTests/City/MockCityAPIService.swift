//
//  MockCItyAPIService.swift
//  WeatherTests
//
//  Created by Pratyush Pratik Sinha on 17/09/23.
//

import Foundation
@testable import Weather

final class MockCityAPIServiceSuccess: APIServiceProvider {
    func request<T: URN>(with URN: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void) where T : URN {
        if let success = CityWeatherForecastResponse(cod: "cod", message: 45, cnt: 7, list: [.init(dt: 3243235, main: .init(temp: 35, tempMin: 27, tempMax: 45, feelsLike: 37, pressure: 1016, seaLevel: 1016, grndLevel: 1009, humidity: 86, tempKf: 35), weather: [.init(id: 46, main: "main", description: "description", icon: "icon")], clouds: .init(all: 34), wind: .init(speed: 60, deg: 45, gust: 30), visibility: 45, pop: 34, sys: .init(pod: "pod"), dtTxt: "dtText")], city: .init(id: 34, name: "name", coord: .init(lat: -118.24, lon: 33.9731), country: "India", population: 1500000000, timezone: 3423432, sunrise: 3243224, sunset: 3243278)) as? T.Derived {
            onCompletion(.success(success))
        }
    }
}

final class MockCityAPIServiceError: APIServiceProvider {
    func request<T: URN>(with URN: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void) where T : URN {
        onCompletion(.failure(.customError(error: "Testing Error")))
    }
}

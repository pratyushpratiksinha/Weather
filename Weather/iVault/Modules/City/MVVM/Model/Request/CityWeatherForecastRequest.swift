//
//  CityWeatherForecastRequest.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation

// MARK: - CityWeatherForecastRequest
struct CityWeatherForecastRequest: Encodable {
    let lat: String
    let lon: String
    let appid: String
    let cnt: String
}

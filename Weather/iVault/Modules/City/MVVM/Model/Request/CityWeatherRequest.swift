//
//  CityWeatherRequest.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

// MARK: - CityWeatherResponse
struct CityWeatherRequest: Encodable {
    let lat: String
    let lon: String
    let appid: String
}

//
//  CityForecastRequest.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation

// MARK: - CityForecastRequest
struct CityForecastRequest: Encodable {
    let lat: String
    let lon: String
    let appid: String
    let cnt: Int
}

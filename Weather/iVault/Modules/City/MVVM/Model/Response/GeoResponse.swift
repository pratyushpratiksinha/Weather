//
//  GeoResponse.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation

// MARK: - GeoResponse
struct GeoResponse: Decodable {
    let zip, name: String
    let lat, lon: Double
    let country: String
}

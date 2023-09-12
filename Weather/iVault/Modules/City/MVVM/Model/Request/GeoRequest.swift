//
//  GeoRequest.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation

// MARK: - GeoRequest
struct GeoRequest: Encodable {
    let zip: String
    let appid: String
}

//
//  ConfigurationConstants.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

//MARK: - ConfigurationKey
///keys to retrieve from configuration files
enum ConfigurationKey: String {
    case baseURL = "API_BASE_URL"
    case appId = "API_KEY"
    case geoURL = "API_GEO_URL"
    case iconURL = "API_ICON_URL"
}

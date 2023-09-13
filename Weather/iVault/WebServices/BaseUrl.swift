//
//  BaseURL.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

//MARK: - Network Base Url
public enum BaseUrl : String {
    case base
    case geo
    case icon
    
    public var rawValue: String {
        switch self {
        case .base:
            let baseURL: String = "https://" + (try! Configuration.value(for: .baseURL))
            return baseURL
        case .geo:
            let geoURL: String = "https://" + (try! Configuration.value(for: .geoURL))
            return geoURL
        case .icon:
            let iconURL: String = "https://" + (try! Configuration.value(for: .iconURL)) + "/"
            return iconURL
        }
    }
}

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
    
    public var rawValue: String {
        switch self {
        case .base:
            let baseURL: String = "https://" + (try! Configuration.value(for: .baseURL))
            return baseURL
        case .geo:
            let baseURL: String = "https://" + (try! Configuration.value(for: .geoURL))
            return baseURL
        }
    }
}

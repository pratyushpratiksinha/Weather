//
//  WeatherExerciseNetworkURN.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation
import CoreLocation

protocol WeatherExerciseNetworkURN: URN {}

extension WeatherExerciseNetworkURN {
    
    var method: HTTPMethod {
        return .get
    }
}

struct GETWeatherDataURN: WeatherExerciseNetworkURN {
    
    var location: CLLocation
    
    typealias Derived = CityWeatherResponse
    
    var baseURL: BaseUrl {
        return .base
    }
    
    var endPoint: EndPoints {
        return .weather
    }
    
    var parameters: [String : String]? {
        let lat: String = "\(location.coordinate.latitude.rounded(toPlaces: 2))"
        let lng: String = "\(location.coordinate.longitude.rounded(toPlaces: 2))"
        let appId: String = try! Configuration.value(for: .appId)
        
        if let params = CityWeatherRequest(lat: lat, lon: lng, appid: appId).toDictionary as? [String: String] {
            return params
        } else {
            return nil
        }
    }
}

struct GETGeoDataURN: WeatherExerciseNetworkURN {
    
    var zip: String
    
    typealias Derived = GeoResponse
    
    var baseURL: BaseUrl {
        return .geo
    }
    
    var endPoint: EndPoints {
        return .zip
    }
    
    var parameters: [String : String]? {
        let zip: String = "\(zip)"
        let appId: String = try! Configuration.value(for: .appId)
        
        if let params = GeoRequest(zip: zip, appid: appId).toDictionary as? [String: String] {
            return params
        } else {
            return nil
        }
    }
}

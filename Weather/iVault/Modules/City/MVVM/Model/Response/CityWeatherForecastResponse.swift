//
//  CityWeatherForecastResponse.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation

// MARK: - CityWeatherForecastResponse
struct CityWeatherForecastResponse: Decodable {
    let cod: String?
    let message, cnt: Int?
    let list: [CityWeather]?
    let city: City?
}

extension CityWeatherForecastResponse {
    // MARK: - City
    struct City: Decodable {
        let id: Int
        let name: String?
        let coord: Coord?
        let country: String?
        let population, timezone, sunrise, sunset: Int?
    }
    
    // MARK: - List
    struct CityWeather: Decodable, Hashable {
        let dt: Int
        let main: Main
        let weather: [Weather]?
        let clouds: Clouds?
        let wind: Wind?
        let visibility, pop: Int?
        let sys: Sys?
        let dtTxt: String?

        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, sys
            case dtTxt = "dt_txt"
        }
        
        static func == (lhs: CityWeather, rhs: CityWeather) -> Bool {
            lhs.dt == rhs.dt && lhs.main == rhs.main && lhs.weather == rhs.weather && lhs.clouds == rhs.clouds && lhs.wind == rhs.wind && lhs.visibility == rhs.visibility && lhs.pop == rhs.pop && lhs.sys == rhs.sys && lhs.dtTxt == rhs.dtTxt
        }
    }
}

extension CityWeatherForecastResponse.City {
    // MARK: - Coord
    struct Coord: Decodable {
        let lat, lon: Double?
    }
}

extension CityWeatherForecastResponse.CityWeather {
    // MARK: - Clouds
    struct Clouds: Decodable, Hashable {
        let all: Int?
    }
    
    // MARK: - Main
    struct Main: Decodable, Hashable {
        let temp, tempMin, tempMax: Double
        let feelsLike: Double?
        let pressure, seaLevel, grndLevel, humidity: Int?
        let tempKf: Double?
        
        var asDictionary : [String: Any?] {
          let mirror = Mirror(reflecting: self)
          let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
          }).compactMap { $0 })
          return dict
        }
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }
    
    // MARK: - Sys
    struct Sys: Decodable, Hashable {
        let pod: String?
    }
    
    // MARK: - Weather
    struct Weather: Decodable, Hashable {
        let id: Int?
        let main, description, icon: String?
    }
    
    // MARK: - Wind
    struct Wind: Decodable, Hashable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }
}

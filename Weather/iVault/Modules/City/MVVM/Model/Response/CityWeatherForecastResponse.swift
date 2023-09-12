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
    let list: [List]?
    let city: City?
}

extension CityWeatherForecastResponse {
    // MARK: - City
    struct City: Decodable {
        let id: Int?
        let name: String?
        let coord: Coord?
        let country: String?
        let population, timezone, sunrise, sunset: Int?
    }
    
    // MARK: - List
    struct List: Decodable {
        let dt: Int?
        let main: Main?
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
    }
}

extension CityWeatherForecastResponse.City {
    // MARK: - Coord
    struct Coord: Decodable {
        let lat, lon: Double?
    }
}

extension CityWeatherForecastResponse.List {
    // MARK: - Clouds
    struct Clouds: Decodable {
        let all: Int?
    }
    
    // MARK: - Main
    struct Main: Decodable {
        let temp, feelsLike, tempMin, tempMax: Double?
        let pressure, seaLevel, grndLevel, humidity: Int?
        let tempKf: Double?
        
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
    struct Sys: Decodable {
        let pod: String?
    }
    
    // MARK: - Weather
    struct Weather: Decodable {
        let id: Int?
        let main, description, icon: String?
    }
    
    // MARK: - Wind
    struct Wind: Decodable {
        let speed: Double?
        let deg: Int?
        let gust: Double?
    }
}

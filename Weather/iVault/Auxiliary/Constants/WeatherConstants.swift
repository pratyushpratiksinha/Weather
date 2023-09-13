//
//  WeatherDescription.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 13/09/23.
//

import UIKit

enum WeatherDescription: String {
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case scatteredClouds = "scattered clouds"
    case brokenClouds = "broken clouds"
    case showerRain = "shower rain"
    case rain = "rain"
    case thunderstorm = "thunderstorm"
    case snow = "snow"
    case mist = "mist"

    var dayIcon: String {
        switch self {
        case .clearSky:
            return "01d@2x.png"
        case .fewClouds:
            return "02d@2x.png"
        case .scatteredClouds:
            return "03d@2x.png"
        case .brokenClouds:
            return "04d@2x.png"
        case .showerRain:
            return "09d@2x.png"
        case .rain:
            return "10d@2x.png"
        case .thunderstorm:
            return "11d@2x.png"
        case .snow:
            return "13d@2x.png"
        case .mist:
            return "50d@2x.png"
        }
    }
    
    var nightIcon: String {
        switch self {
        case .clearSky:
            return "01n@2x.png"
        case .fewClouds:
            return "02n@2x.png"
        case .scatteredClouds:
            return "03n@2x.png"
        case .brokenClouds:
            return "04n@2x.png"
        case .showerRain:
            return "09n@2x.png"
        case .rain:
            return "10n@2x.png"
        case .thunderstorm:
            return "11n@2x.png"
        case .snow:
            return "13n@2x.png"
        case .mist:
            return "50n@2x.png"
        }
    }
}

enum WeatherCondition: String {
    case feelsLike = "feelsLike"
    case pressure = "pressure"
    case seaLevel = "seaLevel"
    case grndLevel = "grndLevel"
    case humidity = "humidity"
    
    var title: String {
        switch self {
        case .feelsLike:
            return "WeatherCondition.Title.FeelsLike".localized
        case .pressure:
            return "WeatherCondition.Title.Pressure".localized
        case .seaLevel:
            return "WeatherCondition.Title.SeaLevel".localized
        case .grndLevel:
            return "WeatherCondition.Title.GroundLevel".localized
        case .humidity:
            return "WeatherCondition.Title.Humidity".localized
        }
    }
}

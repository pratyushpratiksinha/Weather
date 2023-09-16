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
    case overcastClouds = "overcast clouds"
    case showerRain = "shower rain"
    case lightRain = "light rain"
    case rain = "rain"
    case moderateRain = "moderate rain"
    case heavyIntensityRain = "heavy intensity rain"
    case veryHeavyRain = "very heavy rain"
    case extremeRain = "extreme rain"
    case freezingRain = "freezing rain"
    case lightIntensityShowerRain = "light intensity shower rain"
    case heavyIntensityShowerRain = "heavy intensity shower rain"
    case raggedShowerRain = "ragged shower rain"
    case drizzle = "drizzle"
    case lightIntensityDrizzle = "light intensity drizzle"
    case heavyIntensityDrizzle = "heavy intensity drizzle"
    case drizzleRain = "drizzle rain"
    case lightIntensityDrizzleRain = "light intensity drizzle rain"
    case heavyIntensityDrizzleRain = "heavy intensity drizzle rain"
    case showerRainAndDrizzle = "shower rain and drizzle"
    case heavyShowerRainAndDrizzle = "heavy shower rain and drizzle"
    case showerDrizzle = "shower drizzle"
    case thunderstorm = "thunderstorm"
    case thunderstormWithLightRain = "thunderstorm with light rain"
    case thunderstormWithRain = "thunderstorm with rain"
    case thunderstormWithHeavyRain = "thunderstorm with heavy rain"
    case lightThunderstorm = "light thunderstorm"
    case heavyThunderstorm = "heavy thunderstorm"
    case raggedThunderstorm = "ragged thunderstorm"
    case thunderstormWithLightDrizzle = "thunderstorm with light drizzle"
    case thunderstormWithDrizzle = "thunderstorm with drizzle"
    case thunderstormWithHeavyDrizzle = "thunderstorm with heavy drizzle"
    case snow = "snow"
    case lightSnow = "light snow"
    case heavySnow = "heavy snow"
    case sleet = "sleet"
    case lightShowerSleet = "light shower sleet"
    case showerSleet = "shower sleet"
    case lightRainAndSnow = "light rain and snow"
    case rainAndSnow = "rain and snow"
    case lightShowerSnow = "light shower snow"
    case showerSnow = "shower snow"
    case heavyShowerSnow = "heavy shower snow"
    case mist = "mist"
    case smoke = "smoke"
    case haze = "haze"
    case sandDustWhirls = "sand/dust whirls"
    case fog = "fog"
    case sand = "sand"
    case dust = "dust"
    case volcanicAsh = "volcanic ash"
    case squalls = "squalls"
    case tornado = "tornado"
    
    var dayImage: String {
        switch self {
        case .clearSky:
            return "imageClearSkyDay"
        case .fewClouds:
            return "imageFewCloudsDay"
        case .scatteredClouds, .brokenClouds, .overcastClouds:
            return "imageScatteredCloudsDay"
        case .showerRain, .rain, .lightRain, .moderateRain, .heavyIntensityRain, .veryHeavyRain, .extremeRain, .heavyIntensityShowerRain, .lightIntensityShowerRain, .freezingRain, .raggedShowerRain, .drizzle, .lightIntensityDrizzle, .heavyIntensityDrizzle, .drizzleRain, .lightIntensityDrizzleRain, .heavyIntensityDrizzleRain, .showerRainAndDrizzle, .heavyShowerRainAndDrizzle, .showerDrizzle:
            return "imageRainDay"
        case .thunderstorm, .thunderstormWithLightRain, .thunderstormWithRain, .thunderstormWithHeavyRain, .lightThunderstorm, .heavyThunderstorm, .raggedThunderstorm, .thunderstormWithLightDrizzle, .thunderstormWithDrizzle, .thunderstormWithHeavyDrizzle:
            return "imageThunderstormDay"
        case .snow, .lightSnow, .heavySnow, .sleet, .lightShowerSleet, .showerSleet, .lightRainAndSnow, .rainAndSnow, .lightShowerSnow, .showerSnow, .heavyShowerSnow:
            return "imageSnowDay"
        case .mist, .smoke, .fog:
            return "imageMistDay"
        case .haze:
            return "imageHaze"
        case .sandDustWhirls:
            return "imageSandDustWhirls"
        case .sand:
            return "imageSand"
        case .dust:
            return "imageDust"
        case .volcanicAsh:
            return "imageVolcanicAsh"
        case .squalls:
            return "imageSqualls"
        case .tornado:
            return "imageTornado"
        }
    }
    
    var nightImage: String {
        switch self {
        case .clearSky:
            return "imageClearSkyNight"
        case .fewClouds:
            return "imageFewCloudsNight"
        case .scatteredClouds, .brokenClouds, .overcastClouds:
            return "imageScatteredCloudsNight"
        case .showerRain, .rain, .lightRain, .moderateRain, .heavyIntensityRain, .veryHeavyRain, .extremeRain, .heavyIntensityShowerRain, .lightIntensityShowerRain, .freezingRain, .raggedShowerRain, .drizzle, .lightIntensityDrizzle, .heavyIntensityDrizzle, .drizzleRain, .lightIntensityDrizzleRain, .heavyIntensityDrizzleRain, .showerRainAndDrizzle, .heavyShowerRainAndDrizzle, .showerDrizzle:
            return "imageRainNight"
        case .thunderstorm, .thunderstormWithLightRain, .thunderstormWithRain, .thunderstormWithHeavyRain, .lightThunderstorm, .heavyThunderstorm, .raggedThunderstorm, .thunderstormWithLightDrizzle, .thunderstormWithDrizzle, .thunderstormWithHeavyDrizzle:
            return "imageThunderstormNight"
        case .snow, .lightSnow, .heavySnow, .sleet, .lightShowerSleet, .showerSleet, .lightRainAndSnow, .rainAndSnow, .lightShowerSnow, .showerSnow, .heavyShowerSnow:
            return "imageSnowNight"
        case .mist, .smoke, .fog:
            return "imageMistNight"
        case .haze:
            return "imageHaze"
        case .sandDustWhirls:
            return "imageSandDustWhirls"
        case .sand:
            return "imageSand"
        case .dust:
            return "imageDust"
        case .volcanicAsh:
            return "imageVolcanicAsh"
        case .squalls:
            return "imageSqualls"
        case .tornado:
            return "imageTornado"
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

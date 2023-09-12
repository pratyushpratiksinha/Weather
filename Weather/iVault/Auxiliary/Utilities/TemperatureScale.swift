//
//  TemperatureScale.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation

enum TemperatureScale {
    case celsius
    case fahrenheit
}

protocol TemperatureScaleConversionDataSource {
    func convertCelsiusToFahrenheit(_ c: Double) -> Double
    func convertFahrenheitToCelsius(_ f: Double) -> Double
    func convertKelvinToCelsius(_ k: Double) -> Double
}

extension TemperatureScaleConversionDataSource where Self: AnyObject {
    func convertCelsiusToFahrenheit(_ c: Double) -> Double {
        return (c * 9/5) + 32
    }
    
    func convertFahrenheitToCelsius(_ f: Double) -> Double {
        return (f - 32) * 5/9
    }
    
    func convertKelvinToCelsius(_ k: Double) -> Double {
        return k - 273.15
    }
}

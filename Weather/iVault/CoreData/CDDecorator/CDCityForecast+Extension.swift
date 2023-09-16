//
//  CDCityForecast+Extension.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 15/09/23.
//

import Foundation

extension CDCityForecast {
    func convertToCityForecastWeatherDataCVCModel() -> CityForecastWeatherDataCVCModel {
        return CityForecastWeatherDataCVCModel(id: Int(self.id), dt: Int(self.dt), day: self.day ?? "", icon: self.icon ?? "", temperatureHigh: self.temperatureHigh, temperatureLow: self.temperatureLow)
    }
}

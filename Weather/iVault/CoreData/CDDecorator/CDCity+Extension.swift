//
//  CDCity+Extension.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 15/09/23.
//

import Foundation
import CoreLocation

extension CDCity {
    func convertToCityTVCModel() -> CityTVCModel {
        return CityTVCModel(id: Int(self.id), cityName: self.cityName ?? "" , countryName: self.countryName ?? "", weatherDescription: self.weatherDescription ?? "", backgroundImage: self.backgroundImage, temperatureCurrent: self.temperatureCurrent, temperatureHigh: self.temperatureHigh, temperatureLow: self.temperatureLow, location: CLLocation(latitude: self.latitude, longitude: self.longitude), forecast: convertToCityForecastWeatherDataCVCModel(), condition: convertToCityConditionWeatherDataCVCModel())
    }

    private func convertToCityForecastWeatherDataCVCModel() -> [CityForecastWeatherDataCVCModel]? {
        guard self.toForecast != nil && self.toForecast?.count != 0 else {return nil}
        var forecastList: [CityForecastWeatherDataCVCModel] = []
        self.toForecast?.forEach({ (forecast) in
            forecastList.append(forecast.convertToCityForecastWeatherDataCVCModel())
        })
        return forecastList
    }
    
    private func convertToCityConditionWeatherDataCVCModel() -> [CityConditionWeatherDataCVCModel]? {
        guard self.toCondition != nil && self.toCondition?.count != 0 else {return nil}
        var conditionList: [CityConditionWeatherDataCVCModel] = []
        self.toCondition?.forEach({ (condition) in
            conditionList.append(condition.convertToCityConditionWeatherDataCVCModel())
        })
        return conditionList
    }
}

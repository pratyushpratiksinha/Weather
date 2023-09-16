//
//  CDCityCondition+Extension.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 15/09/23.
//

import Foundation

extension CDCityCondition {
    func convertToCityConditionWeatherDataCVCModel() -> CityConditionWeatherDataCVCModel {
        return CityConditionWeatherDataCVCModel(id: Int(self.id), title: self.title ?? "", message: self.message ?? "")
    }
}

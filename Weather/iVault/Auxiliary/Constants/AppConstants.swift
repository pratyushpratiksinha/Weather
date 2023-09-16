//
//  AppConstants.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

enum ReusableIdentifierTVC: String {
    case CityTVC = "CityTVC"
}

enum ReusableIdentifierCVC: String {
    case CityTodayWeatherDataCVC = "CityTodayWeatherDataCVC"
    case CityForecastWeatherDataCVC = "CityForecastWeatherDataCVC"
    case CityConditionWeatherDataCVC = "CityConditionWeatherDataCVC"
}

enum ReusableIdentifierCRV: String {
    case SectionHeaderCRV = "SectionHeaderCRV"
}

enum UserDefaultsKeys: String {
    case temperatureScale = "temperatureScale"
    case isTemperatureScaleModified = "isTemperatureScaleModified"
}

enum ElementOperation {
    case created
    case deleted
    case updated
    case currentLocationCreated
    case none
}

enum CoreDataModel {
    case existing
    case notExisting
}

enum LocationOperation {
    case once
    case none
}

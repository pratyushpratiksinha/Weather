//
//  AppConstants.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

//MARK: - ReusableIdentifierTVC
///reusable identifiers for UITableViewCell
enum ReusableIdentifierTVC: String {
    case CityTVC = "CityTVC"
}

//MARK: - ReusableIdentifierCVC
//reusable identifiers for UICollectionViewCell
enum ReusableIdentifierCVC: String {
    case CityTodayWeatherDataCVC = "CityTodayWeatherDataCVC"
    case CityForecastWeatherDataCVC = "CityForecastWeatherDataCVC"
    case CityConditionWeatherDataCVC = "CityConditionWeatherDataCVC"
}

//MARK: - ReusableIdentifierCRV
///reusable identifiers for UICollectionReuableView
enum ReusableIdentifierCRV: String {
    case SectionHeaderCRV = "SectionHeaderCRV"
}

//MARK: - UserDefaultsKeys
//keys for saving and retrieving from UserDefaults
enum UserDefaultsKeys: String {
    case temperatureScale = "temperatureScale"
}

//MARK: - ElementOperation
///operations on elements
enum ElementOperation {
    case created
    case deleted
    case updated
    case currentLocationCreated
    case none
}

//MARK: - CoreDataModel
///coredata model checker
enum CoreDataModel {
    case existing
    case notExisting
}

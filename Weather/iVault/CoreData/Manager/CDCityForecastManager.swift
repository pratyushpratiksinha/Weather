//
//  CDCityForecastManager.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 16/09/23.
//

import Foundation

struct CDCityForecastManager {
    
    private let repository = CityForecastRepository()
    
    func create(record: CityForecastWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        repository.create(record: record, onCompletion: onCompletion)
    }

    func getAll() -> [CityForecastWeatherDataCVCModel]? {
        repository.getAll()
    }
    
    func get(byIdentifier id: Int, onCompletion: @escaping (CityForecastWeatherDataCVCModel?) -> Void) {
        repository.get(byIdentifier: id, onCompletion: onCompletion)
    }
    
    func update(record: CityForecastWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        repository.update(record: record, onCompletion: onCompletion)
    }
    
    func delete(byIdentifier id: Int, onCompletion: @escaping (Bool) -> Void) {
        repository.delete(byIdentifier: id, onCompletion: onCompletion)
    }
}

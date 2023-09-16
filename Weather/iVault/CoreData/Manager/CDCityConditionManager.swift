//
//  CDCityConditionManager.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 16/09/23.
//

import Foundation

struct CDCityConditionManager {
    
    private let repository = CityConditionRepository()
    
    func create(record: CityConditionWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        repository.create(record: record, onCompletion: onCompletion)
    }

    func getAll() -> [CityConditionWeatherDataCVCModel]? {
        repository.getAll()
    }
    
    func get(byIdentifier id: Int, onCompletion: @escaping (CityConditionWeatherDataCVCModel?) -> Void) {
        repository.get(byIdentifier: id, onCompletion: onCompletion)
    }
    
    func update(record: CityConditionWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        repository.update(record: record, onCompletion: onCompletion)
    }
    
    func delete(byIdentifier id: Int, onCompletion: @escaping (Bool) -> Void) {
        repository.delete(byIdentifier: id, onCompletion: onCompletion)
    }
}

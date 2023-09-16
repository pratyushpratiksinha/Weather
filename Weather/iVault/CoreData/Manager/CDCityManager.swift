//
//  CDCityManager.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 16/09/23.
//

import Foundation

struct CDCityManager {
    
    private let repository = CityListRepository()
    
    func create(record: CityTVCModel, onCompletion: @escaping (Bool) -> Void) {
        repository.create(record: record, onCompletion: onCompletion)
    }

    func getAll() -> [CityTVCModel]? {
        repository.getAll()
    }
    
    func get(byIdentifier id: Int, onCompletion: @escaping (CityTVCModel?) -> Void) {
        repository.get(byIdentifier: id, onCompletion: onCompletion)
    }
    
    func update(record: CityTVCModel, onCompletion: @escaping (Bool) -> Void) {
        repository.update(record: record, onCompletion: onCompletion)
    }
    
    func update(records: [CityTVCModel], onCompletion: @escaping (Bool) -> Void) {
        for index in 0..<records.count {
            self.update(record: records[index]) { isUpdated in
                if isUpdated == false {
                    onCompletion(false)
                }
                if index == records.count - 1 {
                    onCompletion(true)
                }
            }
        }
    }
    
    func delete(byIdentifier id: Int, onCompletion: @escaping (Bool) -> Void) {
        repository.delete(byIdentifier: id, onCompletion: onCompletion)
    }
}

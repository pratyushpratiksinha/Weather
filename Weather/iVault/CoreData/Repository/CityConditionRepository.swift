//
//  CityConditionRepository.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 15/09/23.
//

import Foundation
import CoreData

protocol CityConditionDataRepository : CoreDataRepository {}

struct CityConditionRepository : CityConditionDataRepository {
    
    typealias T = CityConditionWeatherDataCVCModel

    func create(record: CityConditionWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            let cdCityCondition = CDCityCondition(context: PersistentStorage.shared.context)
            cdCityCondition.id = Int64(record.id)
            cdCityCondition.title = record.title
            cdCityCondition.message = record.message
            if privateManagedContext.hasChanges {
                try? privateManagedContext.save()
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        }
    }
    
    func getAll() -> [CityConditionWeatherDataCVCModel]? {
        let records = PersistentStorage.shared.fetchManagedObject(managedObject: CDCityCondition.self)
        guard records != nil && records?.count != 0 else { return nil }
        var results: [CityConditionWeatherDataCVCModel] = []
        records?.forEach({ (cdCityCondition) in
            results.append(cdCityCondition.convertToCityConditionWeatherDataCVCModel())
        })
        return results
    }
    
    func get(byIdentifier id: Int, onCompletion: @escaping (CityConditionWeatherDataCVCModel?) -> Void) {
        getCdCityCondition(byId: id) { cityCondition in
            guard let cityCondition = cityCondition else { return onCompletion(nil) }
            onCompletion(cityCondition.convertToCityConditionWeatherDataCVCModel())
        }
    }
    
    func update(record: CityConditionWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            getCdCityCondition(byId: record.id) { cityCondition in
                guard let cityCondition = cityCondition else { return onCompletion(false) }
                cityCondition.title = record.title
                cityCondition.message = record.message
                if privateManagedContext.hasChanges {
                    try? privateManagedContext.save()
                    onCompletion(true)
                } else {
                    onCompletion(false)
                }
            }
        }
    }
    
    func delete(byIdentifier id: Int, onCompletion: @escaping (Bool) -> Void) {
        getCdCityCondition(byId: id) { cityCondition in
            guard let cityCondition = cityCondition else { return onCompletion(false) }
            PersistentStorage.shared.context.delete(cityCondition)
            PersistentStorage.shared.saveContext()
            onCompletion(true)
        }
    }
    
    private func getCdCityCondition(byId id: Int, onCompletion: @escaping (CDCityCondition?) -> Void) {
        PersistentStorage.shared.context.perform {
            let fetchRequest = NSFetchRequest<CDCityCondition>(entityName: "CDCityCondition")
            let fetchById = NSPredicate(format: "id == %@", NSNumber(value: id))
            fetchRequest.predicate = fetchById
            let result = try? PersistentStorage.shared.context.fetch(fetchRequest)
            guard result?.count != 0 else { return onCompletion(nil) }
            onCompletion(result?.first)
        }
    }
}

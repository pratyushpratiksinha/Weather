//
//  CityForecastRepository.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 15/09/23.
//

import Foundation
import CoreData

protocol CityForecastDataRepository : CoreDataRepository {}

struct CityForecastRepository : CityForecastDataRepository {
    
    typealias T = CityForecastWeatherDataCVCModel

    func create(record: CityForecastWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            let cdCityForecast = CDCityForecast(context: PersistentStorage.shared.context)
            cdCityForecast.id = Int64(record.id)
            cdCityForecast.day = record.day
            cdCityForecast.icon = record.icon
            cdCityForecast.temperatureHigh = record.temperatureHigh
            cdCityForecast.temperatureLow = record.temperatureLow
            if privateManagedContext.hasChanges {
                try? privateManagedContext.save()
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        }
    }
    
    func getAll() -> [CityForecastWeatherDataCVCModel]? {
        guard let records = PersistentStorage.shared.fetchManagedObject(managedObject: CDCityForecast.self),
              records.count != 0 else {
            return nil
        }
        var results: [CityForecastWeatherDataCVCModel] = []
        records.forEach({ (cdCityForecast) in
            results.append(cdCityForecast.convertToCityForecastWeatherDataCVCModel())
        })
        return results
    }
    
    func get(byIdentifier id: Int, onCompletion: @escaping (CityForecastWeatherDataCVCModel?) -> Void) {
        getCdCityForecast(byId: id) { cityForecast in
            guard let cityForecast = cityForecast else { return onCompletion(nil) }
            onCompletion(cityForecast.convertToCityForecastWeatherDataCVCModel())
        }
    }
    
    func update(record: CityForecastWeatherDataCVCModel, onCompletion: @escaping (Bool) -> Void) {
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            getCdCityForecast(byId: record.id) { cityForecast in
                guard let cityForecast = cityForecast else { return onCompletion(false) }
                cityForecast.day = record.day
                cityForecast.icon = record.icon
                cityForecast.temperatureHigh = record.temperatureHigh
                cityForecast.temperatureLow = record.temperatureLow
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
        getCdCityForecast(byId: id) { cityForecast in
            guard let cityForecast = cityForecast else { return onCompletion(false) }
            PersistentStorage.shared.context.delete(cityForecast)
            PersistentStorage.shared.saveContext()
            onCompletion(true)
        }
    }
    
    private func getCdCityForecast(byId id: Int, onCompletion: @escaping (CDCityForecast?) -> Void) {
        PersistentStorage.shared.context.perform {
            let fetchRequest = NSFetchRequest<CDCityForecast>(entityName: "CDCityForecast")
            let fetchById = NSPredicate(format: "id == %@", NSNumber(value: id))
            fetchRequest.predicate = fetchById
            let result = try? PersistentStorage.shared.context.fetch(fetchRequest)
            guard result?.count != 0 else { return onCompletion(nil) }
            onCompletion(result?.first)
        }
    }
}

//
//  CityDataRepository.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 15/09/23.
//

import Foundation
import CoreData

protocol CityListDataRepository : CoreDataRepository {}

struct CityListRepository : CityListDataRepository {
    
    typealias T = CityTVCModel
    
    func create(record: CityTVCModel, onCompletion: @escaping (Bool) -> Void) {
        PersistentStorage.shared.persistentContainer.performBackgroundTask { privateManagedContext in
            let cdCity = CDCity(context: privateManagedContext)
            cdCity.id = Int64(record.id)
            cdCity.cityName = record.cityName
            cdCity.countryName = record.countryName
            cdCity.weatherDescription = record.weatherDescription
            cdCity.backgroundImage = record.backgroundImage
            cdCity.temperatureCurrent = record.temperatureCurrent
            cdCity.temperatureHigh = record.temperatureHigh
            cdCity.temperatureLow = record.temperatureLow
            cdCity.latitude = record.location.coordinate.latitude
            cdCity.longitude = record.location.coordinate.longitude
            if privateManagedContext.hasChanges {
                try? privateManagedContext.save()
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        }
    }
    
    func getAll() -> [CityTVCModel]? {
        guard let records = PersistentStorage.shared.fetchManagedObject(managedObject: CDCity.self),
              records.count != 0 else {
            return nil
        }
        var results: [CityTVCModel] = []
        records.forEach({ (cdCity) in
            results.append(cdCity.convertToCityTVCModel())
        })
        return results
    }
    
    func get(byIdentifier id: Int, onCompletion: @escaping (CityTVCModel?) -> Void) {
        getCdCity(byId: id) { city in
            guard let city = city else { return onCompletion(nil) }
            onCompletion(city.convertToCityTVCModel())
        }
    }
    
    func update(record: CityTVCModel, onCompletion: @escaping (Bool) -> Void) {
        getCdCity(byId: record.id) { city in
            guard let city = city else { return onCompletion(false) }
            city.cityName = record.cityName
            city.countryName = record.countryName
            city.weatherDescription = record.weatherDescription
            city.backgroundImage = record.backgroundImage
            city.temperatureCurrent = record.temperatureCurrent
            city.temperatureHigh = record.temperatureHigh
            city.temperatureLow = record.temperatureLow
            city.latitude = record.location.coordinate.latitude
            city.longitude = record.location.coordinate.longitude
            
            if let forecastList = record.forecast,
               forecastList.count != 0 {
                var forecastSet = Set<CDCityForecast>()
                forecastList.forEach({ (forecast) in
                    let cdCityForecast = CDCityForecast(context: PersistentStorage.shared.context)
                    cdCityForecast.id = Int64(forecast.id)
                    cdCityForecast.day = forecast.day
                    cdCityForecast.icon = forecast.icon
                    cdCityForecast.temperatureHigh = forecast.temperatureHigh
                    cdCityForecast.temperatureLow = forecast.temperatureLow
                    forecastSet.insert(cdCityForecast)
                })
                city.toForecast = forecastSet
            }
            
            if let conditionList = record.condition,
               conditionList.count != 0 {
                var conditionSet = Set<CDCityCondition>()
                conditionList.forEach({ (condition) in
                    let cdCityCondition = CDCityCondition(context: PersistentStorage.shared.context)
                    cdCityCondition.id = Int64(condition.id)
                    cdCityCondition.title = condition.title
                    cdCityCondition.message = condition.message
                    conditionSet.insert(cdCityCondition)
                })
                city.toCondition = conditionSet
            }
            
            PersistentStorage.shared.saveContext()
            onCompletion(true)
        }
    }
    
    func delete(byIdentifier id: Int, onCompletion: @escaping (Bool) -> Void) {
        getCdCity(byId: id) { city in
            guard let city = city else { return onCompletion(false) }
            PersistentStorage.shared.context.delete(city)
            PersistentStorage.shared.saveContext()
            onCompletion(true)
        }
    }
    
    private func getCdCity(byId id: Int, onCompletion: @escaping (CDCity?) -> Void) {
        PersistentStorage.shared.context.perform {
            let fetchRequest = NSFetchRequest<CDCity>(entityName: "CDCity")
            let fetchById = NSPredicate(format: "id == %@", NSNumber(value: id))
            fetchRequest.predicate = fetchById
            let result = try? PersistentStorage.shared.context.fetch(fetchRequest)
            guard result?.count != 0 else { return onCompletion(nil) }
            onCompletion(result?.first)
        }
    }
}

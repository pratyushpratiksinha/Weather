//
//  CDCity+CoreDataProperties.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 17/09/23.
//
//

import Foundation
import CoreData


extension CDCity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCity> {
        return NSFetchRequest<CDCity>(entityName: "CDCity")
    }

    @NSManaged public var backgroundImage: String?
    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var temperatureCurrent: Double
    @NSManaged public var temperatureHigh: Double
    @NSManaged public var temperatureLow: Double
    @NSManaged public var weatherDescription: String?
    @NSManaged public var scale: String?
    @NSManaged public var toForecast: Set<CDCityForecast>?
    @NSManaged public var toCondition: Set<CDCityCondition>?

}

// MARK: Generated accessors for toCondition
extension CDCity {

    @objc(addToConditionObject:)
    @NSManaged public func addToToCondition(_ value: CDCityCondition)

    @objc(removeToConditionObject:)
    @NSManaged public func removeFromToCondition(_ value: CDCityCondition)

    @objc(addToCondition:)
    @NSManaged public func addToToCondition(_ values: NSSet)

    @objc(removeToCondition:)
    @NSManaged public func removeFromToCondition(_ values: NSSet)

}

// MARK: Generated accessors for toForecast
extension CDCity {

    @objc(addToForecastObject:)
    @NSManaged public func addToToForecast(_ value: CDCityForecast)

    @objc(removeToForecastObject:)
    @NSManaged public func removeFromToForecast(_ value: CDCityForecast)

    @objc(addToForecast:)
    @NSManaged public func addToToForecast(_ values: NSSet)

    @objc(removeToForecast:)
    @NSManaged public func removeFromToForecast(_ values: NSSet)

}

extension CDCity : Identifiable {

}

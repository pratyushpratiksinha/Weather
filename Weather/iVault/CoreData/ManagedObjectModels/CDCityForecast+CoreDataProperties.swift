//
//  CDCityForecast+CoreDataProperties.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 17/09/23.
//
//

import Foundation
import CoreData


extension CDCityForecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCityForecast> {
        return NSFetchRequest<CDCityForecast>(entityName: "CDCityForecast")
    }

    @NSManaged public var day: String?
    @NSManaged public var dt: Int64
    @NSManaged public var icon: String?
    @NSManaged public var id: Int64
    @NSManaged public var temperatureHigh: Double
    @NSManaged public var temperatureLow: Double
    @NSManaged public var toCity: CDCity?

}

extension CDCityForecast : Identifiable {

}

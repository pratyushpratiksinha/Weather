//
//  CDCityCondition+CoreDataProperties.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 17/09/23.
//
//

import Foundation
import CoreData


extension CDCityCondition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCityCondition> {
        return NSFetchRequest<CDCityCondition>(entityName: "CDCityCondition")
    }

    @NSManaged public var id: Int64
    @NSManaged public var message: String?
    @NSManaged public var title: String?
    @NSManaged public var toCity: CDCity?

}

extension CDCityCondition : Identifiable {

}

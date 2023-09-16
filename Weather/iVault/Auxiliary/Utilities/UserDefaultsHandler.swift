//
//  UserDefaultsHandler.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 16/09/23.
//

import Foundation

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

extension UserDefault where Value: ExpressibleByNilLiteral {
    init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            // Check whether we're dealing with an optional and remove the object if the new value is nil.
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
        }
    }

    var projectedValue: Bool {
        return true
    }
}

extension UserDefaults {

    @UserDefault(key: UserDefaultsKeys.temperatureScale.rawValue)
    static var temperatureScale: String?
    
    @UserDefault(key: UserDefaultsKeys.isTemperatureScaleModified.rawValue, defaultValue: false)
    static var isTemperatureScaleModified: Bool?
}

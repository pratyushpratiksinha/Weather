//
//  AppIngredients.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

struct AppIngredients {
    
    /// Returns true if RELEASE mode is active
    public static var isRelease: Bool {
        #if DEBUG
            return false
        #else
            return true
        #endif
    }
}

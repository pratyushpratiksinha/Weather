//
//  Location.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit
import CoreLocation

protocol LocationDelegate {
    func hasLocationPermission() -> Bool
}

extension LocationDelegate where Self: UIViewController {
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                    break
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
}

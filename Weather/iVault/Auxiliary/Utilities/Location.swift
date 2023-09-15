//
//  Location.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit
import CoreLocation

protocol LocationDelegate {
    func hasLocationPermission(onCompletion: (Bool) -> Void)
}

extension LocationDelegate where Self: UIViewController {
    func hasLocationPermission(onCompletion: (Bool) -> Void) {
        let manager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                onCompletion(false)
            case .authorizedAlways, .authorizedWhenInUse:
                onCompletion(true)
            @unknown default:
                    break
            }
        } else {
            onCompletion(false)
        }
    }
}

//
//  Location.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit
import CoreLocation

//MARK: - LocationOperation
///location operation checker
enum LocationOperation {
    case once
    case none
}

//MARK: - LocationDelegate
protocol LocationDelegate {
    func hasLocationPermission(onCompletion: (Bool) -> Void)
}

extension LocationDelegate where Self: UIViewController {
    func hasLocationPermission(onCompletion: (Bool) -> Void) {
        let manager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .denied:
                onCompletion(false)
            case .authorizedAlways, .authorizedWhenInUse:
                onCompletion(true)
            default:
                break
            }
        } else {
            onCompletion(false)
        }
    }
}

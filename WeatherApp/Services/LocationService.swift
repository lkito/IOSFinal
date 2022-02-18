//
//  LocationService.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/17/22.
//

import Foundation
import CoreLocation


class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping ((CLLocation) -> Void)) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
}

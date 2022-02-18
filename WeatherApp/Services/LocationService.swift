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
    
    public func getLocationName(location: CLLocation, completion: @escaping (Result<String, Error>) -> ()){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let placemark = placemarks?.first else {
                completion(.failure(LocationServiceError.noLocationName))
                return
            }
            guard let city = placemark.locality, let country = placemark.country else {
                completion(.failure(LocationServiceError.noLocationName))
                return
            }
//            var subLocality = ""
//            if let sub = placemark.subLocality {
//                subLocality = sub + ", "
//            }
            completion(.success(city + ", " + country))
        })
    }
}


enum LocationServiceError: Error {
    case noLocationName
}

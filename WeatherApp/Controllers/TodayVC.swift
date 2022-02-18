//
//  TodayVC.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/16/22.
//

import UIKit
import CoreLocation

class TodayVC: UIViewController {
    @IBOutlet var cloudDetail: WeatherDetailsView!
    @IBOutlet var humidityDetail: WeatherDetailsView!
    @IBOutlet var pressureDetail: WeatherDetailsView!
    @IBOutlet var windVelocityDetail: WeatherDetailsView!
    @IBOutlet var windDirectionDetail: WeatherDetailsView!
    
    private let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        cloudDetail.fillData(iconName: "raining.pdf", detailValue: "1")
        humidityDetail.fillData(iconName: "drop.pdf", detailValue: "1")
        pressureDetail.fillData(iconName: "celsius.pdf", detailValue: "1")
        windVelocityDetail.fillData(iconName: "wind.pdf", detailValue: "1")
        windDirectionDetail.fillData(iconName: "compass.pdf", detailValue: "1")
        
        LocationService.shared.getUserLocation(completion: { [weak self] location in
            guard let strongSelf = self else {
                return
            }
            LocationService.shared.getLocationName(location: location, completion: { result in
                switch result {
                    case .success(let location):
                        print(location)
                    case .failure(let error):
                        print(error)
                }
            })
            strongSelf.weatherService.getFiveDayForecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { result in
                switch result {
                    case .success(let weather):
                        print(weather)
                    case .failure(let error):
                        print(error)
                }
            }
        })
        
        
        weatherService.getWeatherImage(imageName: "02n") { result in
            switch result {
                case .success(let weather):
                    print(weather)
                case .failure(let error):
                    print(error)
            }

        }
    }


}


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
    
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var blur: UIVisualEffectView!
    
    private let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        blur.isHidden = true
        cloudDetail.setIcon(iconName: "raining.pdf")
        humidityDetail.setIcon(iconName: "drop.pdf")
        pressureDetail.setIcon(iconName: "celsius.pdf")
        windVelocityDetail.setIcon(iconName: "wind.pdf")
        windDirectionDetail.setIcon(iconName: "compass.pdf")
        
        loadTodayWeatherData()
    }
    
    private func visualizeWeatherDetails(weather: CurrentWeatherResponse, strongSelf: TodayVC) {
        if weather.weather.count == 0 {
            strongSelf.blur.isHidden = true
            strongSelf.loader.stopAnimating()
            return
        }
        let firstWeather = weather.weather[0]
        strongSelf.weatherLabel.text = String(Int(weather.main.temp)) + "°C | " + firstWeather.main
        strongSelf.cloudDetail.setDetail(detailValue: String(weather.clouds.all) + " %")
        strongSelf.humidityDetail.setDetail(detailValue: String(weather.main.humidity) + " mm")
        strongSelf.pressureDetail.setDetail(detailValue: String(weather.main.pressure) + " hPa")
        strongSelf.windVelocityDetail.setDetail(detailValue: String(weather.wind.speed) + " km/h")
        strongSelf.windDirectionDetail.setDetail(detailValue: LocationService.shared.degreesToDirection(degrees: weather.wind.deg))
        
        strongSelf.weatherService.getWeatherImage(imageName: firstWeather.icon, completion: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                    case .success(let image):
                        strongSelf.weatherImage.image = image
                    case .failure(let error):
                        print(error)
                }
                strongSelf.blur.isHidden = true
                strongSelf.loader.stopAnimating()
            }
        })
    }

    private func loadWeatherDetails(location: CLLocation, strongSelf: TodayVC) {
        strongSelf.weatherService.getCurrentWeather(lat: location.coordinate.latitude,
                                                    lon: location.coordinate.longitude) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                switch result {
                    case .success(let weather):
                        strongSelf.visualizeWeatherDetails(weather: weather, strongSelf: strongSelf)
                    case .failure(let error):
                        strongSelf.blur.isHidden = true
                        strongSelf.loader.stopAnimating()
                        print(error)
                }
            }
        }
    }
    
    private func loadTodayWeatherData() {
        loader.startAnimating()
        blur.isHidden = false
        LocationService.shared.getUserLocation(completion: { [weak self] location in
            guard let strongSelf = self else {
                return
            }
            LocationService.shared.getLocationName(location: location, completion: { [weak self] result in
                DispatchQueue.main.async {
                    guard let strongSelf = self else {
                        return
                    }
                    switch result {
                        case .success(let locationName):
                            strongSelf.locationLabel.text = locationName
                        case .failure(let error):
                            strongSelf.blur.isHidden = true
                            strongSelf.loader.stopAnimating()
                            print(error)
                    }
                }
            })
            strongSelf.loadWeatherDetails(location: location, strongSelf: strongSelf)
        })
    }

}


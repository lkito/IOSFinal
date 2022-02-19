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
    
    @IBOutlet var errorScreen: UIView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var errorButton: UIButton!
    
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var blur: UIVisualEffectView!
    
    private let weatherService = WeatherService()
    
    // Variables for feature testing
    private let MinimumLoadingTime: Double = 0.5
    private let ErrorChancePercent: Int = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        errorButton.layer.cornerRadius = 5
        blur.isHidden = true
        errorScreen.isHidden = true
        cloudDetail.setIcon(iconName: "raining.pdf")
        humidityDetail.setIcon(iconName: "drop.pdf")
        pressureDetail.setIcon(iconName: "celsius.pdf")
        windVelocityDetail.setIcon(iconName: "wind.pdf")
        windDirectionDetail.setIcon(iconName: "compass.pdf")
        
        loadTodayWeatherData()
    }
    
    @IBAction func share() {
        var sharedText = ""
        if let loc = self.locationLabel.text {
            sharedText = loc + " - "
        }
        sharedText += self.weatherLabel.text ?? ""
        let shareSheetVC = UIActivityViewController(activityItems: [
             sharedText
        ], applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
    
    @IBAction func refreshFromError() {
        loadTodayWeatherData()
    }
    
    @IBAction func refresh() {
        loadTodayWeatherData()
    }
    
    private func displayError(errorMessages: String) {
        DispatchQueue.main.async {
            self.blur.isHidden = true
            self.errorLabel.text = errorMessages
            self.errorScreen.isHidden = false
            self.loader.stopAnimating()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    private func visualizeWeatherDetails(weather: CurrentWeatherResponse, strongSelf: TodayVC) {
        if weather.weather.count == 0 {
            strongSelf.displayError(errorMessages: "Couldn't retrieve weather data from servers.")
            return
        }
        let firstWeather = weather.weather[0]
        strongSelf.weatherLabel.text = String(Int(weather.main.temp)) + "°C | " + firstWeather.main
        strongSelf.cloudDetail.setDetail(detailValue: String(weather.clouds.all) + " %")
        strongSelf.humidityDetail.setDetail(detailValue: String(weather.main.humidity) + " mm")
        strongSelf.pressureDetail.setDetail(detailValue: String(weather.main.pressure) + " hPa")
        strongSelf.windVelocityDetail.setDetail(detailValue: String(weather.wind.speed) + " km/h")
        strongSelf.windDirectionDetail.setDetail(detailValue: LocationService.shared.degreesToDirection(degrees: weather.wind.deg))
        strongSelf.weatherService.getWeatherImage(imageName: firstWeather.icon, completion: { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let image):
                        let flip = arc4random_uniform(100)
                        if (flip < strongSelf.ErrorChancePercent){
                            strongSelf.displayError(errorMessages: "Application error when fetching weather image.")
                            return
                        }
                        strongSelf.weatherImage.image = image
                    case .failure(let error):
                        strongSelf.displayError(errorMessages: "Application error when fetching weather image.")
                        print(error)
                }
                strongSelf.blur.isHidden = true
                strongSelf.loader.stopAnimating()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        })
    }

    private func loadWeatherDetails(location: CLLocation, strongSelf: TodayVC) {
        strongSelf.weatherService.getCurrentWeather(lat: location.coordinate.latitude,
                                                    lon: location.coordinate.longitude) { result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let weather):
                        strongSelf.visualizeWeatherDetails(weather: weather, strongSelf: strongSelf)
                    case .failure(let error):
                        strongSelf.displayError(errorMessages: "Application error when fetching weather data.")
                        print(error)
                }
            }
        }
    }
    
    private func loadTodayWeatherData() {
        errorScreen.isHidden = true
        loader.startAnimating()
        blur.isHidden = false
        
        LocationService.shared.getUserLocation(completion: { [weak self] location in
            guard let strongSelf = self else {
                return
            }
            LocationService.shared.getLocationName(location: location, completion: { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let locationName):
                            strongSelf.locationLabel.text = locationName
                        case .failure(let error):
                            strongSelf.displayError(errorMessages: "Application error when fetching location.")
                            print(error)
                    }
                }
            })
            // Lets the user take in all the work I put in animating the loading screen
            DispatchQueue.main.asyncAfter(deadline: .now() + strongSelf.MinimumLoadingTime) {
                strongSelf.loadWeatherDetails(location: location, strongSelf: strongSelf)
            }
        })
    }

}


//
//  ForecastVC.swift
//  WeatherApp
//
//  Created by Lasha Kitiashvili on 2/19/22.
//

import UIKit
import CoreLocation


class ForecastVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var forecastData: [(day: Date, weatherData: [FiveDayForecastList])] = []
    
    
    private let weatherService = WeatherService()
    
    // Variables for feature testing
    private let MinimumLoadingTime: Double = 0.5
    private let ErrorChancePercent: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: "ForecastCell")
        
        fetchForecastData()
    }
    
    
    private func displayError(errorMessages: String) {
//        blur.isHidden = true
//        errorLabel.text = errorMessages
//        errorScreen.isHidden = false
//        loader.stopAnimating()
    }
    
    private func storeForecastDetails(forecast: FiveDayForecastResponse, strongSelf: ForecastVC) {
        if forecast.list.count == 0 {
            strongSelf.displayError(errorMessages: "Couldn't retrieve forecast data from the servers.")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var currentDay: Date = Date()
        var currentDayWeathers: [FiveDayForecastList] = []
        for weather in forecast.list {
            guard let day = dateFormatter.date(from: weather.dtTxt)?.stripTime() else {
                continue
            }
            if (currentDay != day) {
                if (currentDayWeathers.count > 0) {
                    strongSelf.forecastData.append((currentDay, currentDayWeathers))
                }
                currentDay = day
                currentDayWeathers = []
            }
            currentDayWeathers.append(weather)
        }
        
        DispatchQueue.main.async {
            strongSelf.tableView.reloadData()
        }
    }
    
    private func loadForecastDetails(location: CLLocation, strongSelf: ForecastVC) {
        strongSelf.weatherService.getFiveDayForecast(lat: location.coordinate.latitude,
                                                     lon: location.coordinate.longitude) { result in
            switch result {
                case .success(let forecast):
                    strongSelf.storeForecastDetails(forecast: forecast, strongSelf: strongSelf)
                case .failure(let error):
                    strongSelf.displayError(errorMessages: "Application error when fetching forecast data.")
                    print(error)
            }
        }
    }
    
    private func fetchForecastData() {
        LocationService.shared.getUserLocation(completion: { [weak self] location in
            guard let strongSelf = self else {
                return
            }
            // Lets the user take in all the work I put in animating the loading screen
            DispatchQueue.main.asyncAfter(deadline: .now() + strongSelf.MinimumLoadingTime) {
                strongSelf.loadForecastDetails(location: location, strongSelf: strongSelf)
            }
        })
    }
}

extension ForecastVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastData[section].weatherData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.forecastData.count
    }
    
    private func getTimeofDay(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var timeOfDay = ""
        if let curDate = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "HH:mm"
            timeOfDay = dateFormatter.string(from: curDate)
        }
        return timeOfDay
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)
        if let forecastCell = cell as? ForecastCell {
            let dataRow = self.forecastData[indexPath.section].weatherData[indexPath.row]
            let timeOfDay = getTimeofDay(dateString: dataRow.dtTxt)
            let firstWeather = dataRow.weather[0]
            var forecastCellModel = ForecastCellModel(weatherImage: UIImage(), timeOfDayText: timeOfDay, weatherStatusText: firstWeather.weatherDescription, temperatureText: String(Int(dataRow.main.temp)))

            self.weatherService.getWeatherImage(imageName: firstWeather.icon, completion: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                    case .success(let image):
                        forecastCellModel.weatherImage = image
                        forecastCell.configure(with: forecastCellModel)
                    case .failure(let error):
                        strongSelf.displayError(errorMessages: "Application error when fetching weather image.")
                        print(error)
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

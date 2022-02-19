// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct CurrentWeatherResponse: Codable {
    let coord: CurrentWeatherCoord
    let weather: [CurrentWeatherWeather]
    let base: String
    let main: CurrentWeatherMain
    let visibility: Int
    let wind: CurrentWeatherWind
    let clouds: CurrentWeatherClouds
    let dt: Int
    let sys: CurrentWeatherSys
    let timezone, id: Int
    let name: String
    let cod: Int

    enum CodingKeys: String, CodingKey {
        case coord = "coord"
        case weather = "weather"
        case base
        case main = "main"
        case visibility
        case wind = "wind"
        case clouds = "clouds"
        case dt
        case sys = "sys"
        case timezone, id, name, cod
    }
}

// MARK: - CurrentWeatherClouds
struct CurrentWeatherClouds: Codable {
    let all: Int
}

// MARK: - CurrentWeatherCoord
struct CurrentWeatherCoord: Codable {
    let lon, lat: Double
}

// MARK: - CurrentWeatherMain
struct CurrentWeatherMain: Codable {
    let temp, feelsLike, tempMin, tempMax, pressure: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - CurrentWeatherSys
struct CurrentWeatherSys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - CurrentWeatherWeather
struct CurrentWeatherWeather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - CurrentWeatherWind
struct CurrentWeatherWind: Codable {
    let speed: Double
    let deg: Double
    let gust: Double?
}

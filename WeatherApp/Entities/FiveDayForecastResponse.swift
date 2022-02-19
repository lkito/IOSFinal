// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct FiveDayForecastResponse: Codable {
    let cod: String
    let message, cnt: Int
    let list: [FiveDayForecastList]
    let city: FiveDayForecastCity

    enum CodingKeys: String, CodingKey {
        case cod, message, cnt
        case list = "list"
        case city = "city"
    }
}

// MARK: - FiveDayForecastCity
struct FiveDayForecastCity: Codable {
    let id: Int
    let name: String
    let coord: FiveDayForecastCoord
    let country: String
    let population, timezone, sunrise, sunset: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case coord = "coord"
        case country, population, timezone, sunrise, sunset
    }
}

// MARK: - FiveDayForecastCoord
struct FiveDayForecastCoord: Codable {
    let lat, lon: Double
}

// MARK: - FiveDayForecastList
struct FiveDayForecastList: Codable {
    let dt: Int
    let main: FiveDayForecastMainClass
    let weather: [FiveDayForecastWeather]
    let clouds: FiveDayForecastClouds
    let wind: FiveDayForecastWind
    let visibility: Int
    let pop: Double
    let rain: FiveDayForecastRain?
    let sys: FiveDayForecastSys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case visibility, pop
        case rain = "rain"
        case sys = "sys"
        case dtTxt = "dt_txt"
    }
}

// MARK: - FiveDayForecastClouds
struct FiveDayForecastClouds: Codable {
    let all: Int
}

// MARK: - FiveDayForecastMainClass
struct FiveDayForecastMainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - FiveDayForecastRain
struct FiveDayForecastRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - FiveDayForecastSys
struct FiveDayForecastSys: Codable {
    let pod: FiveDayForecastPod

    enum CodingKeys: String, CodingKey {
        case pod = "pod"
    }
}

enum FiveDayForecastPod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - FiveDayForecastWeather
struct FiveDayForecastWeather: Codable {
    let id: Int
    let main: FiveDayForecastMainEnum
    let weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case main = "main"
        case weatherDescription = "description"
        case icon
    }
}

enum FiveDayForecastMainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
    case extreme = "Extreme"
}

// MARK: - FiveDayForecastWind
struct FiveDayForecastWind: Codable {
    let speed: Double
    let deg: Double
    let gust: Double?
}

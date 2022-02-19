import Foundation
import SDWebImage

class WeatherService {
    
    private var apiUrlComponents = URLComponents()
    private var baseUrlComponents = URLComponents()
	private let apiKey = "2371a117a269ce3c420e823f83edc637"
	
	init() {
        apiUrlComponents.scheme = "https"
        apiUrlComponents.host = "api.openweathermap.org"
        baseUrlComponents.scheme = "https"
        baseUrlComponents.host = "openweathermap.org"
	}
	
	
	func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (Result<CurrentWeatherResponse, Error>) -> ()) {
		apiUrlComponents.path = "/data/2.5/weather"
        let parameters = [
            "lat": lat.description,
            "lon": lon.description,
            "appid": apiKey.description,
            "units": "metric"
        ] as [String : String]
		apiUrlComponents.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
		}
		
		if let url = apiUrlComponents.url {
			let request = URLRequest(url: url)

			let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
				if let error = error {
					completion(.failure(error))
					return
				}
			
				if let data = data {
					let decoder = JSONDecoder()
					do {
						let result = try decoder.decode(CurrentWeatherResponse.self, from: data)
						completion(.success(result))
					} catch {
						completion(.failure(error))
					}
				} else {
					completion(.failure(WeatherServiceError.noData))
				}
			})
			task.resume()
		} else {
			completion(.failure(WeatherServiceError.invalidParameters))
		}
	}
	
    
    func getFiveDayForecast(lat: Double, lon: Double, completion: @escaping (Result<FiveDayForecastResponse, Error>) -> ()) {
        apiUrlComponents.path = "/data/2.5/forecast"
        let parameters = [
            "lat": lat.description,
            "lon": lon.description,
            "appid": apiKey.description,
            "units": "metric"
        ] as [String : String]
        apiUrlComponents.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = apiUrlComponents.url {
            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
            
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(FiveDayForecastResponse.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(WeatherServiceError.noData))
                }
            })
            task.resume()
        } else {
            completion(.failure(WeatherServiceError.invalidParameters))
        }
    }
    
    func getWeatherImage(imageName: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        baseUrlComponents.path = "/img/wn/\(imageName)@2x.png"
        if let url = baseUrlComponents.url {
            let imageManager = SDWebImageManager()
            
            imageManager.loadImage(with: url, options: [], progress: {
                (receivedSize, totalSize, url) in
                let percentage = (Float(receivedSize) / Float(totalSize)) * 100.0
                print("Image downloading progress: \(percentage)%")
            }, completed: { (image, data, err, cacheType, finished, url) in
                if let err = err {
                    completion(.failure(err))
                } else if let image = image {
                    completion(.success(image))
                } else {
                    completion(.failure(WeatherServiceError.imageUnwrapError))
                }
            })
        } else {
            completion(.failure(WeatherServiceError.invalidParameters))
        }
    }
}

enum WeatherServiceError: Error {
	case noData
    case invalidParameters
    case imageUnwrapError
}

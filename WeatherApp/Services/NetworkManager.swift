//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Роман Васильев on 24.05.2023.
//

import Foundation

final class NetworkManager {
    private let baseURL = "http://api.openweathermap.org"
    private let apiKey = "9eec06aef89d2a6969b925b9d6c926d4"
    
    private enum Endpoint {
        case currentWeather(city: String)
        case forecast(city: String, numberOfHours: Int)
        case group(cityIDs: String)
        
        var path: String {
            switch self {
            case .currentWeather:
                return "/data/2.5/weather"
            case .forecast:
                return "/data/2.5/forecast"
            case .group:
                return "/data/2.5/group"
            }
        }
        
        var parameters: [URLQueryItem] {
            switch self {
            case let .currentWeather(city):
                return [
                    URLQueryItem(name: "q", value: city),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "appid", value: NetworkManager.shared.apiKey)
                ]
            case let .forecast(city, numberOfHours):
                return [
                    URLQueryItem(name: "q", value: city),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "cnt", value: String(numberOfHours)),
                    URLQueryItem(name: "appid", value: NetworkManager.shared.apiKey)
                ]
            case let .group(cityIDs):
                return [
                    URLQueryItem(name: "id", value: cityIDs),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "appid", value: NetworkManager.shared.apiKey)
                ]
            }
        }
        
        var url: URL? {
            var components = URLComponents(string: NetworkManager.shared.baseURL)
            components?.path = path
            components?.queryItems = parameters
            return components?.url
        }
    }
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private func fetchData<T: Decodable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> ()) {
        guard let url = endpoint.url else {
            print("error tut")

            completion(.failure(.invalidResponse))
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("error requestFailed")
                completion(.failure(.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                print("error invalidData")
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("error decodingFailed")
                completion(.failure(.decodingFailed(error)))
            }
        }.resume()
    }
    
    
}

extension NetworkManager: CurrentWeatherService {
    func fetchCurrentWeather(city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ()) {
        fetchData(endpoint: .currentWeather(city: city), completion: completion)
    }
}

extension NetworkManager: CityWeatherService {
    func fetchForecast(city: String, numberOfHours: Int, completion: @escaping (Result<ForecastResponse, NetworkError>) -> ()) {
        fetchData(endpoint: .forecast(city: city, numberOfHours: numberOfHours), completion: completion)
    }
}


extension NetworkManager: FavoriteCitiesWatherService {
    func fetchCurrentTemperatureForCities(cityIDs: [Int], completion: @escaping (Result<WeatherGroupResponse, NetworkError>) -> ()) {
        let cityIDsString = cityIDs.map(String.init).joined(separator: ",")
        fetchData(endpoint: Endpoint.group(cityIDs: cityIDsString), completion: completion)
    }
}

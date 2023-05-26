//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Роман Васильев on 25.05.2023.
//

import Foundation

protocol CurrentWeatherService {
    func fetchCurrentWeather(city: String, completion: @escaping (Result<WeatherResponse, NetworkError>) -> ())
}
protocol CityWeatherService {
    func fetchForecast(city: String, numberOfHours: Int, completion: @escaping (Result<ForecastResponse, NetworkError>) -> ())
}

protocol FavoriteCitiesWatherService {
    func fetchCurrentTemperatureForCities(cityIDs: [Int], completion: @escaping (Result<WeatherGroupResponse, NetworkError>) -> ())
}




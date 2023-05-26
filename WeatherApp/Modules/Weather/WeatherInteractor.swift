//
//  WeatherInteractor.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import Foundation

protocol WeatherInteractorProtocol {
    func getCitiesCount() -> Int
    func getCityAtIndex(_ index: Int) -> WeatherResponse
    func fetchCitiesWeather()
    func fetchCityWeather(_ cityName: String)
}

protocol WeatherInteractorOutput: AnyObject {
    func weatherUploaded()
    func handleError(_ error: String)
}

final class WeatherInteractor: WeatherInteractorProtocol {
    
    var presenter: WeatherInteractorOutput?
    private var weatherService: NetworkManager
    private var favoritesService: FavoritesService
    private var cities = [WeatherResponse]()
    private var defaultCities: [Int] = []
    
    init(weatherService: NetworkManager, favoritesService: FavoritesService) {
        self.weatherService = weatherService
        self.favoritesService = favoritesService
        let favorites = favoritesService.getFavoriteCities()
        defaultCities.append(contentsOf: favorites)
    }
    
    func getCitiesCount() -> Int {
        return cities.count
    }
    
    func getCityAtIndex(_ index: Int) -> WeatherResponse {
        return cities[index]
    }
    
    func fetchCitiesWeather() {
        defaultCities = favoritesService.getFavoriteCities()
        weatherService.fetchCurrentTemperatureForCities(cityIDs: defaultCities) { [self] result in
            switch result {
            case .success(let groupResponse):
                handleSuccess(groupResponse.list)
            case .failure(let errorResponse):
                DispatchQueue.main.async { [self] in
                    presenter?.handleError(errorResponse.localizedDescription)
                }
            }
        }
    }
    
    private func handleSuccess(_ list: [WeatherResponse]?) {
        guard let list else { return }
        DispatchQueue.main.async { [self] in
            cities = list
            presenter?.weatherUploaded()
        }
    }
    
}

extension WeatherInteractor {
    func fetchCityWeather(_ cityName: String) {
        weatherService.fetchCurrentWeather(city: cityName) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let city):
                    let isExistingCity = cities.contains { $0.id == city.id }
                    if !isExistingCity {
                        cities.insert(city, at: 0)
                        presenter?.weatherUploaded()
                    }
                case .failure(let error):
                    presenter?.handleError(error.localizedDescription)
                }
            }

        }
    }
}

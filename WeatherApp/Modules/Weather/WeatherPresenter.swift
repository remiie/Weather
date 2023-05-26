//
//  WeatherPresenter.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import UIKit
protocol WeatherViewOutput: AnyObject {
    func getCitiesCount() -> Int
    func getCityName(at: IndexPath) -> String
    func getCityTemperature(at: IndexPath) -> Int
    func didSelectCity(_ at: IndexPath)
    func viewDidLoad()
    func handleError(_ error: String)
    func weatherUploaded()
    func searchCities(_ cityName: String)
}

final class WeatherPresenter: WeatherViewOutput{

    weak var view: WeatherViewInput?
    private let interactor: WeatherInteractorProtocol
    private let router: WeatherRouterProtocol
    
    init(interactor: WeatherInteractorProtocol, router: WeatherRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchCitiesWeather()
    }
    
    func getCitiesCount() -> Int {
        return interactor.getCitiesCount()
    }
    func getCityName(at: IndexPath) -> String {
        return interactor.getCityAtIndex(at.row).name
    }
    func getCityTemperature(at: IndexPath) -> Int {
        return Int(interactor.getCityAtIndex(at.row).main.temp)
    }
    
}

extension WeatherPresenter {
    func searchCities(_ cityName: String) {
        print("old = \(cityName)")
        let formattedCityName = formatCityName(cityName)
        print("new = \(formattedCityName)")
        interactor.fetchCityWeather(formattedCityName)
    }
}

extension WeatherPresenter {
    func didSelectCity(_ at: IndexPath) {
        let city = interactor.getCityAtIndex(at.row)
        router.navigateToCityModule(with: city.name, id: city.id)
    }

}

extension WeatherPresenter: WeatherInteractorOutput {
    func weatherUploaded() {
        view?.showCities()
        view?.endRefreshing()
    }
    func handleError(_ error: String) {
        view?.showErrorMessage(error)
        view?.endRefreshing()
    }
    
    private func formatCityName(_ cityName: String) -> String {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let trimmedCityName = cityName.trimmingCharacters(in: allowedCharacterSet.inverted)
        let components = trimmedCityName.components(separatedBy: CharacterSet.whitespaces)
        let filteredComponents = components.filter { !$0.isEmpty }
        let formattedCityName = filteredComponents.joined(separator: " ")
        return formattedCityName
    }


}




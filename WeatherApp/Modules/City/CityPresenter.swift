//
//  CityPresenter.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import Foundation
enum ActionState {
    case add
    case remove
}
protocol CityViewOutput: AnyObject {
    func viewDidLoad()
    func actionButtonTapped()
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(_ section: Int) -> Int
    func getTitleForSection(_ section: Int) -> String
    func getTitleForCell(at: IndexPath) -> String
    func getTemperatureForCell(at: IndexPath) -> String
    
}

final class CityPresenter: CityViewOutput {
    
    weak var view: CityViewInput? {
        didSet { view?.updateTitle(city) }
    }
    var interactor: CityInteractorInput!
    var router: CityRouterProtocol!
    
    var id: Int
    private let city: String

    init(interactor: CityInteractorInput, router: CityRouterProtocol, city: String, id: Int) {
        self.id = id
        self.city = city
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchCityWeather(name: city)
        let state: ActionState = getActionForCity(id)
        view?.updateButton(state)
        
    }
    
    func actionButtonTapped() {
        interactor.handleFavoriteButtonTap(cityID: id)
        let state: ActionState = getActionForCity(id)
        view?.updateButton(state)
    }
    
    func getActionForCity(_ id: Int) -> ActionState {
        if interactor.isFavorite(cityID: id) {
            return .remove
        } else {
            return .add
        }
    }
    
    func getNumberOfSections() -> Int {
        return  interactor.getSections()
    }
    
    func getNumberOfRowsInSection(_ section: Int) -> Int {
        return  interactor.getItemsAt(section)
    }
    
    func getTitleForSection(_ section: Int) -> String {
        return  interactor.getTitleFor(section)
    }
    
    func getTitleForCell(at: IndexPath) -> String {
        return  interactor.getTitleForItem(at)
    }
    
    func getTemperatureForCell(at: IndexPath) -> String {
        return "\(interactor.getTemperatureForItem(at))"
    }
}

extension CityPresenter: CityInteractorOutput {
    func weatherUploaded() {
        view?.showWeather()
    }
    
    func handleError(_ error: String) {
        print(error)
    }
    
}





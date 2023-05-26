//
//  WeatherRouter.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import UIKit

protocol WeatherRouterProtocol {
    var viewController: UIViewController? { get set }
    func createModule() -> UIViewController
    func navigateToCityModule(with city: String, id: Int)
}

final class WeatherRouter: WeatherRouterProtocol {
    weak var viewController: UIViewController?
    
    func createModule() -> UIViewController {
        let view = WeatherView()
        let interactor = WeatherInteractor(weatherService: NetworkManager.shared, favoritesService: FavoritesService.shared)
        let presenter = WeatherPresenter(interactor: interactor, router: self)
        interactor.presenter = presenter
        view.presenter = presenter
        presenter.view = view
        viewController = view
        return view
    }
    
    func navigateToCityModule(with city: String, id: Int) {
        let cityModule = CityRouter.createModule(with: city, id: id)
        viewController?.navigationController?.pushViewController(cityModule, animated: true)
    }
    
}

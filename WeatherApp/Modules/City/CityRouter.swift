//
//  CityRouter.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import UIKit
protocol CityRouterProtocol: AnyObject {
    static func createModule(with city: String, id: Int) -> UIViewController
}

final class CityRouter: CityRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(with city: String, id: Int) -> UIViewController {
        let view = CityView()
        let router = CityRouter()
        let interactor = CityInteractor(weatherService: NetworkManager.shared, favoritesService: FavoritesService.shared)
        let presenter = CityPresenter(interactor: interactor, router: router, city: city, id: id)
        interactor.presenter = presenter
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
}



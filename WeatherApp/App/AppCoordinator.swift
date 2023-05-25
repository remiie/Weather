//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Роман Васильев on 24.05.2023.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow?
    private let weatherRouter: WeatherRouterProtocol
    private var navigationController: UINavigationController?
    
    init(window: UIWindow?) {
        self.window = window
        self.weatherRouter = WeatherRouter()
    }
    
    func start() {
        let weatherModule = weatherRouter.createModule()
        navigationController = UINavigationController(rootViewController: weatherModule)
        navigationController?.navigationBar.tintColor = .black
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


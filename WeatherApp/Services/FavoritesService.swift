//
//  FavoritesService.swift
//  WeatherApp
//
//  Created by Роман Васильев on 25.05.2023.
//

import Foundation

final class FavoritesService {
    private let favoritesKey = "favorites"
    private init() {}
    static let shared = FavoritesService()
    
    func isFavoriteCity(_ cityID: Int) -> Bool {
        let favorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        return favorites.contains(cityID)
    }
    
    func addToFavorites(cityID: Int) {
        var favorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        favorites.append(cityID)
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    

    func removeFromFavorites(cityID: Int) {
        var favorites = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        if let index = favorites.firstIndex(of: cityID) {
            favorites.remove(at: index)
            UserDefaults.standard.set(favorites, forKey: favoritesKey)
        }
    }
    
    func getFavoriteCities() -> [Int] {
          return UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
      }
    
}

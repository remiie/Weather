//
//  CityInteractor.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import Foundation

protocol CityInteractorInput: AnyObject {
    func fetchCityWeather(name: String)
    func getSections() -> Int
    func getItemsAt(_ section: Int) -> Int
    func getTitleFor(_ section: Int) -> String
    func getTitleForItem(_ at: IndexPath) -> String
    func getTemperatureForItem(_ at: IndexPath) -> Int
    func handleFavoriteButtonTap(cityID: Int)
    func isFavorite(cityID: Int) -> Bool
}

protocol CityInteractorOutput: AnyObject {
    func weatherUploaded()
    func handleError(_ error: String)
}

final class CityInteractor: CityInteractorInput {
    
    
    weak var presenter: CityInteractorOutput?
    private var weatherService: CityWeatherService
    private let favoritesService: FavoritesService
    private var weatherByDate = WeatherByDate(today: [], threeDays: [], week: [])
    
    init(weatherService: CityWeatherService, favoritesService: FavoritesService) {
        self.weatherService = weatherService
        self.favoritesService = favoritesService
    }
    
    func fetchCityWeather(name: String) {
        weatherService.fetchForecast(city: name, numberOfHours: 40) { [self] result in
            switch result {
            case .success(let success):
                handleSuccess(success)
            case .failure(let error):
                handleError(error.localizedDescription)
            }
        }
    }
    

    
    private func handleSuccess(_ response: ForecastResponse) {
        weatherByDate = groupWeatherByDate(response.list)
        
        DispatchQueue.main.async { [self] in
            presenter?.weatherUploaded()
       
        }
    }
    
    func isFavorite(cityID: Int) -> Bool {
        return favoritesService.isFavoriteCity(cityID)
    }
    
    func handleFavoriteButtonTap(cityID: Int) {
        
        
        if favoritesService.isFavoriteCity(cityID) {
            favoritesService.removeFromFavorites(cityID: cityID)

        } else {
            favoritesService.addToFavorites(cityID: cityID)

        }
    }

    

    
    private func handleError(_ error: String) {
        DispatchQueue.main.async { [self] in
           print(error)
            presenter?.handleError(error)
        }
    }
    
    func getSections() -> Int {
        return 3
    }
    
    func getItemsAt(_ section: Int) -> Int {
        switch section {
            case 0: return weatherByDate.today.count
            case 1: return weatherByDate.threeDays.count
            default: return weatherByDate.week.count
        }
    }
    
    func getTitleFor(_ section: Int) -> String {
        switch section {
            case 0: return "24 HOURS"
            case 1: return "3 DAYS"
            default: return "WEEK"
        }
    }
    
    func getTitleForItem(_ at: IndexPath) -> String {
        
        switch at.section {
            case 0: return formatDateTimeString(dtTxt:  weatherByDate.today[at.row].dt_txt)
            case 1: return formatDateTimeString(dtTxt:  weatherByDate.threeDays[at.row].dt_txt)
            default: return formatDateTimeString(dtTxt:  weatherByDate.week[at.row].dt_txt)
        }
    }
    
    func getTemperatureForItem(_ at: IndexPath) -> Int {
        switch at.section {
            case 0: return Int(weatherByDate.today[at.row].main.temp)
            case 1: return Int(weatherByDate.threeDays[at.row].main.temp)
            default: return Int(weatherByDate.week[at.row].main.temp)
        }
    }
    
    func groupWeatherByDate(_ list: [CityEntity]) -> WeatherByDate {
        var weatherByDate = WeatherByDate(today: [], threeDays: [], week: [])
    
        let currentDate = Date()
        let calendar = Calendar.current
        
        for city in list {
            guard let dateString = city.dt_txt, let date = parseDateString(dateString) else {
                continue
            }
            
            let components = calendar.dateComponents([.day], from: currentDate, to: date)
            guard let daysDifference = components.day else {
                continue
            }
            
            if daysDifference == 0 {
                weatherByDate.today.append(city)
            } else if daysDifference > 0 && daysDifference <= 3 {
                weatherByDate.threeDays.append(city)
            } else if daysDifference > 3 {
                weatherByDate.week.append(city)
            }
        }
        
        return weatherByDate
    }
    
    func parseDateString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return dateFormatter.date(from: dateString)
    }
    
    func formatDateTimeString(dtTxt: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let dtTxt = dtTxt, let date = dateFormatter.date(from: dtTxt) {
            dateFormatter.dateFormat = "dd MMMM HH:mm"
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        
        return "Invalid date format"
    }
}


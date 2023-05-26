//
//  CityEntity.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [CityEntity]
}
struct CityEntity: Decodable {
    let dt: Int?
    let dt_txt: String?
    let main: WeatherEntity
}

struct WeatherByDate {
    var today: [CityEntity]
    var threeDays: [CityEntity]
    var week: [CityEntity]
}


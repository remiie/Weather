//
//  WeatherEntity.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import Foundation


struct WeatherEntity: Decodable{
    var temp: Double
}

struct WeatherGroupResponse: Decodable {
    let list: [WeatherResponse]
}

struct WeatherResponse: Decodable {
    let id: Int
    let name: String
    let main: WeatherEntity
}

//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Роман Васильев on 25.05.2023.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case requestFailed(Error)
    case invalidData
    case decodingFailed(Error)
}

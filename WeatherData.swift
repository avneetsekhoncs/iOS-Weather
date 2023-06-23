//
//  WeatherData.swift
//  Clima
//
//  Created by Avneet Sekhon on 2023-06-22.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

//Structs for API data format
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

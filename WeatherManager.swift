//
//  WeatherManager.swift
//  Clima
//
//  Created by Avneet Sekhon on 2023-06-19.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=af81961ad0da42e5a3bf0ee8b0e5a651&units=metric"
    
    func fetchWeather(cityName: String) {
        let weatherURL = "\(url)&q=\(cityName)"
        performRequest(urlString: weatherURL)
    }
    
    func performRequest(urlString: String) {
        //Create a URL
        if let url = URL(string: urlString){
            //Create a URLSession
            let session = URLSession(configuration: .default)
            //Give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let readData = data {
                    parseJSON(weatherData: readData)
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print (decodedData.weather[0].description)
        } catch {
            print(error)
        }
    }
}

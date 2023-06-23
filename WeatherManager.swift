//
//  WeatherManager.swift
//  Clima
//
//  Created by Avneet Sekhon on 2023-06-19.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    //URL setup
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=af81961ad0da42e5a3bf0ee8b0e5a651&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(url)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //Perform networking to get live data
    func performRequest(with urlString: String) {
        //Create a URL
        if let url = URL(string: urlString){
            //Create a URLSession
            let session = URLSession(configuration: .default)
            //Give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let readData = data {
                    if let weather = self.parseJSON(readData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    //Parse the data
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}

//
//  WeatherManager.swift
//  Clima
//
//  Created by Quentin Laboudigue on 26/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5faec9f5b019dc57af9edfda3ffbc7cc&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchCityWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchLocalWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1) Create a URL
        if let url = URL(string: urlString) {
            // 2) Create a URL session
            let session = URLSession(configuration: .default)
            // 3) Give the session a task
            // let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return // With nothing : Exist this function
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                    }
                }
            }
            // 4) Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
        
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
    
}

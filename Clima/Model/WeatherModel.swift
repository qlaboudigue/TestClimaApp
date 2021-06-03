//
//  WeatherModel.swift
//  Clima
//
//  Created by Quentin Laboudigue on 26/05/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation


struct WeatherModel {
    
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    // Computed properties
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "sun.dust"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.fill"
        default:
            return "sun.max"
        }
    }
    
}

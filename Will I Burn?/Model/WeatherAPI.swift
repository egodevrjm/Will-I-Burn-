//
//  WeatherAPI.swift
//  Will I Burn?
//
//  Created by Ryan Morrison on 09/09/2017.
//  Copyright © 2017 egoDev. All rights reserved.
//

import Foundation

struct WeatherAPI {
    private let baseUrl = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
    private let key = "?key=ddaa077ebd2d4b08a0f173441170909"
    private let numDaysForecast = "&num_of_days="
    private let format = "&format=json"
    
    private var coordString = ""
    
    init(lat: String, lon: String) {
        self.coordString = "&q=\(lat),\(lon)"
    }
    
    func getFullWeatherUrl() -> String {
        return baseUrl + key + coordString + format + numDaysForecast
        
    }
}

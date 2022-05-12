//
//  APIClient.swift
//  WeatherApp
//
//  Created by paige shin on 2022/05/12.
//

import Foundation

class APIClient {

    static let shared: APIClient = APIClient()
    
    let baseURL: String = "https://api.openweathermap.org/data/2.5/weather"
    
    let apiKey: String = ""
    
    func getWeatherData(lat: String, lon: String) -> String {
        return "\(baseURL)?lat=\(lat)&lon=\(lon)"
    }
    
}

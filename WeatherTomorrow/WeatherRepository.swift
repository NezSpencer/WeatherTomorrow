//
//  WeatherRepository.swift
//  WeatherTomorrow
//
//  Created by Nnabueze Uhiara on 14/09/2021.
//

import Foundation
class WeatherRepository {
    let weatherService: WeatherWebService
    
    init(_ weatherService: WeatherWebService) {
        self.weatherService = weatherService
    }
    
    func fetchTomorrowWeatherForCity(city: String, onResponse: @escaping (NetworkState, Weather?) -> Void) {
        weatherService.fetchTomorrowWeatherForCity(city: city, onResponse: onResponse)
    }
    
    static func instance() -> WeatherRepository {
        return WeatherRepository(WeatherWebServiceImpl())
    }
}

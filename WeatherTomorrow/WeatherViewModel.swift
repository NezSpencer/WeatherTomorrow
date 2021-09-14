//
//  WeatherViewModel.swift
//  WeatherTomorrow
//
//  Created by Nnabueze Uhiara on 14/09/2021.
//

import Foundation

class WeatherViewModel {
    let weatherRepository = WeatherRepository.instance()
    
    func fetchCityWeatherForTomorrow(city: String, onResponse: @escaping (NetworkState, Weather?) -> Void) {
        weatherRepository.fetchTomorrowWeatherForCity(city: city, onResponse: onResponse)
    }
}

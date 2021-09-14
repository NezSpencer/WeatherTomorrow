//
//  MockWeatherWebService.swift
//  WeatherTomorrowUITests
//
//  Created by Nnabueze Uhiara on 14/09/2021.
//

import Foundation
@testable import WeatherTomorrow

class MockWeatherWebService: WeatherWebService {
    func fetchTomorrowWeatherForCity(city: String, onResponse: @escaping (NetworkState, Weather?) -> Void){
        if city == "" {
            onResponse(.failed("Blank city"), nil)
        } else {
            fetchCityData(city: city) { state, response in
                switch state {
                case .ok:
                    if response!.woeid == -1 {
                        onResponse(.network("-1 is an invalid city id"), nil)
                    } else  {
                        onResponse(.ok, Weather(id: 1, weather_state_name: "Cloudy", weather_state_abbr: "", min_temp: 25, max_temp: 28, applicable_date: "2021-09-14"))
                    }
                case .failed, .network:
                    onResponse(state, nil)
                }
            }
        }
    }
    
    func fetchCityData(city: String, onResponse: @escaping (NetworkState, CityResponse?) -> Void) {
        let cityData = [CityResponse(title: "dummy city", locationType: "city", woeid: -1, lattLong: "020, 032"), CityResponse(title: "London", locationType: "city", woeid: 23, lattLong: "020, 032")]
        if city.count == 1 {
            onResponse(.network("Network failure. Please retry"), nil)
        } else if city.count == 2 {
            onResponse(.ok, cityData[0])
        } else {
            onResponse(.ok, cityData[1])
        }
    }
}

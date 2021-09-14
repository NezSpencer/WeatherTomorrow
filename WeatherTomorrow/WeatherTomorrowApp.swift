//
//  WeatherTomorrowApp.swift
//  WeatherTomorrow
//
//  Created by Nnabueze Uhiara on 13/09/2021.
//

import SwiftUI

@main
struct WeatherTomorrowApp: App {
    var body: some Scene {
        WindowGroup {
            WeatherScreen(screenData: WeatherScreenData(
                            weather: Weather(id: 1, weather_state_name: "Cloudy", weather_state_abbr: "hr", min_temp: 25, max_temp: 28, applicable_date: "2021-09-14"), city: "Gothenburg"))
        }
    }
}

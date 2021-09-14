//
//  WeatherWebService.swift
//  WeatherTomorrow
//
//  Created by Nnabueze Uhiara on 14/09/2021.
//

import Foundation
import Alamofire

protocol WeatherWebService {
    
    func fetchTomorrowWeatherForCity(city: String, onResponse: @escaping (NetworkState, Weather?) -> Void)
    
}

class WeatherWebServiceImpl: WeatherWebService {
    let cityUrl = "https://www.metaweather.com/api/location/search/?query="
    let weatherUrl = "https://www.metaweather.com/api/location/"
   
    private func fetchCityData(city: String, onResponse: @escaping (NetworkState, CityResponse?) -> Void) {
        let url = cityUrl + city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        AF.request(url, method: .get).responseData {response in
            debug {
                print("WeatherWebService#fetchCityData \n\(url)\n\(String.init(data: response.data ?? "timeout".data(using: .utf8)!, encoding: .utf8)!)")
            }
            if response.error == nil {
                let (state, result) = unmarshal(from: response, type: [CityResponse].self)
                
                onResponse(state, result![0])
            } else {
                onResponse(.failed("Unknown error occurred"), nil)
            }
        }

    }
    
    func fetchTomorrowWeatherForCity(city: String, onResponse: @escaping (NetworkState, Weather?) -> Void) {
        
        fetchCityData(city: city) { state, cityResponse in
            switch state {
            case .ok:
                let calender = Calendar.current
                let tomorrowDate = calender.date(byAdding: .day, value: 1, to: calender.startOfDay(for: Date()))!
                let dateString = convertDate(date: tomorrowDate, toFormat: "YYYY/MM/dd")
                let url = "\(self.weatherUrl)\(cityResponse!.woeid)/\(dateString)"
                AF.request(url, method: .get).responseData {response in
                        debug {
                            print("WeatherWebService#fetchTomorrowWeatherForCity \n\(url)\n\(String.init(data: response.data ?? "timeout".data(using: .utf8)!, encoding: .utf8)!)")
                        }
                    if response.error == nil {
                        let (state, result) = unmarshal(from: response, type: [WeatherResponse].self)
                        if result != nil {
                            onResponse(state, Weather(id: result![0].id, weather_state_name: result![0].weatherStateName, weather_state_abbr: result![0].weatherStateAbbr, min_temp: result![0].minTemp!, max_temp: result![0].maxTemp!, applicable_date: result![0].applicableDate) )
                        } else {
                            onResponse(.failed("Unknown error occurred"), nil)
                        }
                        
                    } else {
                        onResponse(.failed("Unknown error occurred"), nil)
                    }
                }
            case .failed, .network:
                onResponse(state, nil)
            }
        }
        
    }
}

enum NetworkState {
    case failed(String)
    case network(String)
    case ok
}

struct CityResponse: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResponse = try? newJSONDecoder().decode(WeatherResponse.self, from: jsonData)

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let id: Int
    let weatherStateName: String
    let weatherStateAbbr: String
    let applicableDate: String
    let minTemp, maxTemp: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
    }
}




//
//  WeatherReposotoryTests.swift
//  WeatherTomorrowTests
//
//  Created by Nnabueze Uhiara on 14/09/2021.
//

import Foundation
import XCTest
@testable import WeatherTomorrow

class WeatherRepositoryTests: XCTestCase {
    
    let weatherRepository = WeatherRepository(MockWeatherWebService())
    
//    This only touches fetchTomorrowWeatherForCity in WeatherWebService
    func givenInvalidCityErrorIsReturned() throws {
        let expectation = self.expectation(description: "fetching city weather...")
        var response: Weather? = nil
        var responseState: NetworkState? = nil
        weatherRepository.fetchTomorrowWeatherForCity(city: ""){ state, weather in
            response = weather
            responseState = state
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        var isSuccess: Bool = false
        switch responseState {
        case .ok:
            isSuccess = true
        default:
            isSuccess = false
        }
        XCTAssertTrue(response == nil)
        XCTAssertFalse(isSuccess)
    }
    
    // This touches the fetchCityData function in WeatherWebService
    func givenInvalidCityIdErrorIsReturned() throws {
        let expectation = self.expectation(description: "fetching city weather...")
        var response: Weather? = nil
        var responseState: NetworkState? = nil
        //Passing single character city name returns an invalid cityId: -1
        weatherRepository.fetchTomorrowWeatherForCity(city: "1"){ state, weather in
            response = weather
            responseState = state
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        var isSuccess: Bool = false
        switch responseState {
        case .ok:
            isSuccess = true
        default:
            isSuccess = false
        }
        XCTAssertTrue(response == nil)
        XCTAssertFalse(isSuccess)
    }
    
    func givenValidCityIdSuccessIsReturnedWithData() throws {
        let expectation = self.expectation(description: "fetching city weather...")
        var response: Weather? = nil
        var responseState: NetworkState? = nil
        let expectedResponse = Weather(id: 1, weather_state_name: "Cloudy", weather_state_abbr: "", min_temp: 25, max_temp: 28, applicable_date: "2021-09-14")
        //Passing single character city name returns an invalid cityId: -1
        weatherRepository.fetchTomorrowWeatherForCity(city: "Aba"){ state, weather in
            response = weather
            responseState = state
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        var isSuccess: Bool = false
        switch responseState {
        case .ok:
            isSuccess = true
        default:
            isSuccess = false
        }
        XCTAssertTrue(response != nil)
        XCTAssertTrue(response!.weather_state_name == expectedResponse.weather_state_name)
        XCTAssertTrue(isSuccess)
    }
    
}

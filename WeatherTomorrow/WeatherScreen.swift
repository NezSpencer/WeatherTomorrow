//
//  WeatherScreen.swift
//  WeatherTomorrow
//
//  Created by Nnabueze Uhiara on 13/09/2021.
//

import SwiftUI
import Kingfisher

struct WeatherScreen: View {
    @ObservedObject var data: WeatherScreenData
    @State var showSheet = false
    @State var showError = false
    @State var showProgress = false
    
    let viewModel = WeatherViewModel()
    
    init(screenData: WeatherScreenData) {
        self.data = screenData
        fetchCityData(city: "Gothenburg")
    }
    
    private func fetchCityData(city: String) {
        viewModel.fetchCityWeatherForTomorrow(city: city) { state, weather in
            self.showProgress.toggle()
            
            switch state {
            case .ok:
                self.data.city = city
                self.data.weather = weather!
                self.showProgress.toggle()
            case .failed(let message):
                self.showProgress.toggle()
                self.data.errorMessage = message
                self.showError.toggle()
            case .network(let message):
                self.showProgress.toggle()
                self.data.errorMessage = message
                self.showError.toggle()
            }
        }
    }
    var body: some View {
        ZStack {
            VStack(){
                Group{
                    Text(data.city)
                        .font(.largeTitle)
                    Text("Tomorrow \(convertDate(dateString: data.weather.applicable_date))")
                        .font(.subheadline)
                    Spacer().frame(height: 30)
                    KFImage(URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(data.weather.weather_state_abbr).png")!)
                    Text("\(String(format: "%.2f", data.weather.max_temp))\u{00B0}c")
                        .font(.system(size: 40, weight: .heavy, design: .default))
                    Spacer().frame(height: 20)
                }
                Group {
                    Text("---------------")
                    Spacer().frame(height: 20)
                    Text(data.weather.weather_state_name)
                    Spacer().frame(height: 20)
                    Text("\(String(format: "%.2f", data.weather.min_temp))\u{00B0}c / \(String(format: "%.2f", data.weather.max_temp))\u{00B0}c")
                }
                Spacer().frame(height: 20)
                Button("Switch City") {
                    withAnimation{
                        self.showSheet.toggle()
                    }
                }.padding(.all)
                
            }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                    maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                    minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,
                    maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                    alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay(Group{
                if self.showSheet {
                    PartialSheet(isPresented: self.$showSheet, heightFactor: 0.7) {
                        CitySelectorBottomSheet{ city in
                            self.data.city = city
                            fetchCityData(city: city)
                            self.showSheet.toggle()
                            
                        }
                    }
                } else {
                    EmptyView()
                }
            })
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text(data.errorMessage), dismissButton: .default(Text("OK")))
            }.overlay(Group{
                
            })
            
            if showProgress {
                ProgressView(value: 0.4)
                    .frame(width: 60.0, height: 60.0)
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                EmptyView()
            }
        }
    }
}

struct WeatherScreen_Previews: PreviewProvider {
    static var previews: some View {
        WeatherScreen(screenData: WeatherScreenData(
                        weather: Weather(id: 1, weather_state_name: "Cloudy", weather_state_abbr: "", min_temp: 25, max_temp: 28, applicable_date: "2021-09-14"), city: "London"))
    }
}

class WeatherScreenData: ObservableObject {
    @Published var city: String
    @Published var weather: Weather
    var errorMessage: String = "An error occurred"
    
    init(weather: Weather, city: String) {
        self.weather = weather
        self.city = city
    }
}

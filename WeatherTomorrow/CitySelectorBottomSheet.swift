//
//  CitySelectorBottomSheet.swift
//  WeatherTomorrow
//
//  Created by Nnabueze Uhiara on 13/09/2021.
//

import SwiftUI

struct CitySelectorBottomSheet: View {
    var onCityClicked: (String) -> Void
    
    init(onClicked: @escaping (String) -> Void) {
        self.onCityClicked = onClicked
    }
    var body: some View {
        VStack(){
            Button("Gothenburg") {
                self.onCityClicked("Gothenburg")
            }.padding(.all)

            Button("Stockholm") {
                self.onCityClicked("Stockholm")
            }.padding(.all)
            
            Button("Mountain View") {
                self.onCityClicked("Mountain View")
            }.padding(.all)
            
            Button("London") {
                self.onCityClicked("London")
            }.padding(.all)
               
            Button("New York") {
                self.onCityClicked("New York")
            }.padding(.all)
            
            Button("Berlin") {
                self.onCityClicked("Berlin")
            }.padding(.all)
        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).background(Color(.white).ignoresSafeArea(.all))
    }
        

struct CitySelectorBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        CitySelectorBottomSheet{ s in
            
        }
    }
}
}

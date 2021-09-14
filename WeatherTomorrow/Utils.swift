//
//  Utils.swift
//  WeatherTomorrow
//
// https://www.keaura.com/blog/sheets-with-swiftui
//  Created by Nnabueze Uhiara on 13/09/2021.
//

import Foundation
import SwiftUI
import Alamofire

func convertDate(dateString: String, fromFormat: String = "YYY-MM-dd", toFormat: String = "dd MMMM, YYYY")-> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = fromFormat
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = toFormat
    return dateFormatter.string(from: date!)
}

func convertDate(date: Date, toFormat: String = "dd MMMM, YYYY")-> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = toFormat
    return dateFormatter.string(from: date)
}

func debug(action: @escaping () -> Void) {
    #if DEBUG
    action()
    #endif
}

func unmarshal<T: Codable>(from resp: AFDataResponse<Data>, type: T.Type) -> (state: NetworkState, data: T?) {
    switch resp.result {
    case .failure(let err):
        return (NetworkState.network(err.localizedDescription), nil)
    case .success(let result):
        do {
        let data = try JSONDecoder().decode(type, from: result)

           let range = 200 ... 300
           if !range.contains(resp.response?.statusCode ?? 0) {
            return (NetworkState.failed("Unable to retrieve record"), data)
        }

            return (NetworkState.ok, data)
        } catch {

            debug {
                print(error)
            }

            return (NetworkState.network("Unable to decode server response"), nil)
        }
    }
}

func unmarshalDataOnly<T: Codable>(from resp: AFDataResponse<Data>, type: T.Type) -> T? {
    let (_, result) = extractRaw(from: resp, type: type)
    return result
}

func extractRaw<T: Codable>(from resp: AFDataResponse<Data>, type: T.Type) -> (state: NetworkState, data: T?) {
    switch resp.result {
    case .failure(let err):
        return (NetworkState.network(err.localizedDescription), nil)
    case .success(let result):
        do {
        let data = try JSONDecoder().decode(type, from: result)

        if resp.response?.statusCode != 200 {
            return (NetworkState.failed("Unknown server error"), data)
        }

            return (NetworkState.ok, data)
        } catch {
            
            debug {
                print(error)
            }
            
            return (NetworkState.network("Unable to decode server response"), nil)
        }
    }
}


struct PartialSheet<Content: View>: View {
    @Binding var isPresented: Bool
    var content: Content
    let height: CGFloat
    
    @State private var showingContent = false
    
    init(isPresented: Binding<Bool>, heightFactor: CGFloat, @ViewBuilder content: () -> Content) {
        _isPresented = isPresented
        height = heightFactor
        self.content = content()
    }
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottom) {
                BlockingView(isPresented: self.$isPresented, showingContent: self.$showingContent)
                    .zIndex(0) // important to fix the zIndex so that transitions work correctly
                
                if showingContent {
                    self.content
                        .zIndex(1) // important to fix the zIndex so that transitins work correctly
                        .frame(width: reader.size.width, height: reader.size.height * self.height)
                        .clipped()
                        .shadow(radius: 10)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    func hide() {
        showingContent = false
    }
}

private struct BlockingView: View {
    @Binding var isPresented: Bool
    @Binding var showingContent: Bool
    
    // showContent is called when the Color appears and then delays the
    // appearance of the sheet itself so the two don't appear simultaneously.
    
    func showContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation {
                self.showingContent = true
            }
        }
    }

    // hides the sheet first, then after a short delay, makes the blocking
    // view disappear.
    
    func hideContent() {
        withAnimation {
            self.showingContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation {
                self.isPresented = false
            }
        }
    }
    
    var body: some View {
        Color.black.opacity(0.35)
            .onTapGesture {
                self.hideContent()
            }
            .onAppear {
                self.showContent()
            }
    }
}

private struct PartialSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let heightFactor: CGFloat
    let sheet: AnyView
    
    func body(content: Content) -> some View {
        content
            .blur(radius: isPresented ? 4.0 : 0.0)
            .overlay(
                Group {
                    if isPresented {
                        PartialSheet(isPresented: self.$isPresented, heightFactor: heightFactor) {
                            sheet
                        }
                    } else {
                        EmptyView()
                    }
                }
            )
    }
}

extension View {
    func halfSheet<Content: View>(isPresented: Binding<Bool>,
                                  @ViewBuilder content: () -> Content) -> some View {
        self.modifier(PartialSheetModifier(isPresented: isPresented,
                                           heightFactor: 0.5,
                                           sheet: AnyView(content())))
    }
  
    func quarterSheet<Content: View>(isPresented: Binding<Bool>,
                                     @ViewBuilder content: () -> Content) -> some View {
        self.modifier(PartialSheetModifier(isPresented: isPresented,
                                           heightFactor: 0.25,
                                           sheet: AnyView(content())))
    }
}

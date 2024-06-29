//
//  MyWeatherTemplateApp.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 27.06.24.
//

import SwiftUI

@main
struct MyWeatherTemplateApp: App {
    
    @State private var locationManager = LocationManager()
    @State private var store = DataStore()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
            } else {
                ForecastView()
                //LocationDeniedView()
            }
        }
        .environment(locationManager)
        .environment(store)
    }
}

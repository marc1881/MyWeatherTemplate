//
//  ContentView.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 27.06.24.
// 47.763615, 7.896414

import SwiftUI
import WeatherKit
import CoreLocation

struct ForecastView: View {
    @Environment(LocationManager.self) var locationManager
    @Environment(\.scenePhase) var scenePhase
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var hourlyForecast: Forecast<HourWeather>?
    @State private var dailyForecast: Forecast<DayWeather>?
    @State private var isLoading: Bool = false
    @State private var showCityList = false
    @State private var timezone: TimeZone = .current
    
    var highTemperature: String? {
        if let high = hourlyForecast?.map({ $0.temperature }).max() {
            return weatherManager.temperatureFormatter.string(from: high)
        } else {
            return nil
        }
    }
    
    var lowTemperature: String? {
        if let low = hourlyForecast?.map({ $0.temperature }).min() {
            return weatherManager.temperatureFormatter.string(from: low)
        } else {
            return nil
        }
    }
    
    var body: some View {
        VStack {
            Text("Welcome to the Simple Weather App")
                .font(.headline)
                .foregroundStyle(.black)
                .italic()
                .bold()
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.25))
                    .frame(maxWidth: .infinity)
                )
                .padding(10)
          //  ScrollView(.vertical) {
            if let selectedCity {
                if isLoading {
                    ProgressView()
                    Text("Fetching Weather..")
                } else {
                    Text(selectedCity.name)
                        .font(.title)
                        .bold()
                    if let currentWeather {
                        CurrentWeatherView(currentWeather: currentWeather, highTemperature: highTemperature, lowTemperature: lowTemperature, timezone: timezone)
                    }
                    Divider()
                    ScrollView(.vertical) {
                        if let hourlyForecast {
                            HourlyForecastView(hourlyForecast: hourlyForecast, timezone: timezone)
                        }
                        if let dailyForecast {
                            DailyForecastView(dailyForecast: dailyForecast, timezone: timezone)
                        }
                    }
                    .scrollIndicators(.hidden)
                    Spacer()
                    //                    AttributionView()
                    //                        .tint(.white)
                }
            } else {
                ProgressView()
                    .font(.largeTitle)
                    .padding(.bottom, 25)
                Text("Fetching Location & Weather for you....please wait")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
        //}
        //    .scrollIndicators(.hidden)
        }
        .padding()
        .background{
            if selectedCity != nil, let condition = currentWeather?.condition {
                BackgroundView(condition: condition)
            }
        }
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom) {
            HStack {
                AttributionView()
                    .tint(.white)
                Button {
                    showCityList.toggle()
                } label: {
                    Image(systemName: "list.star")
                }
                .padding()
                .background(Color(.darkGray))
                .clipShape(Circle())
                .foregroundStyle(.white)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 20)
        }
        .fullScreenCover(isPresented: $showCityList) {
            CitiesListView(currentLocation: locationManager.currentLocation, selectedCity: $selectedCity)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                selectedCity = locationManager.currentLocation
                if let selectedCity {
                    Task {
                        await fetchWeather(for: selectedCity)
                    }
                }
            }
        }
        .task(id: locationManager.currentLocation) {
            if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                selectedCity = currentLocation
            }
        }
        .task(id: selectedCity) {
            if let selectedCity {
                await fetchWeather(for: selectedCity)
            }
        }
    }
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimeZone(for: city.clLocation)
            hourlyForecast = await weatherManager.hourlyForecast(for: city.clLocation)
            dailyForecast = await weatherManager.dailyForecast(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
        .environment(DataStore(forPreviews: true))
}

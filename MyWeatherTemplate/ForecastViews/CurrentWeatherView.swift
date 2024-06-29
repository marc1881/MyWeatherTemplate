//
//  CurrentWeatherView.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 27.06.24.
//

import SwiftUI
import WeatherKit

struct CurrentWeatherView: View {
    
    let weatherManager = WeatherManager.shared
    let currentWeather: CurrentWeather
    let highTemperature: String?
    let lowTemperature: String?
    let timezone: TimeZone
    
    var body: some View {
        //                        Text(currentWeather.date.formatted(date: .abbreviated, time: .omitted))
        //                        Text(currentWeather.date.formatted(date: .omitted, time: .shortened))
        HStack {
            Text(currentWeather.date.localDate(for: timezone))
            Text(" | ")
            Text(currentWeather.date.localTime(for: timezone))
        }
        Image(systemName: currentWeather.symbolName)
            .renderingMode(.original)
            .symbolVariant(.fill)
            .font(.system(size: 45, weight: .bold))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.secondary.opacity(0.2))
            )
        HStack {
            let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
            Text(temp)
                .font(.title2)
                .bold()
                .padding(.trailing, 15)
            Text(currentWeather.condition.description)
                .font(.title2)
        }
        if let highTemperature, let lowTemperature {
            Text("High: \(highTemperature) | Low: \(lowTemperature)")
                .bold()
                .padding(.bottom, 15)
        }
//        Text(currentWeather.condition.description)
//            .font(.title3)
        VStack(alignment: .leading) {
            HStack {
                Text("Humidity: ")
                Text(String(format: "%.0f", currentWeather.humidity*100) + "%")
                    .padding(.trailing, 10)
                let apparenttemp = weatherManager.temperatureFormatter.string(from: currentWeather.apparentTemperature)
                Text("Apparent: ")
                Text(apparenttemp)
            }
//            HStack {
//                let apparenttemp = weatherManager.temperatureFormatter.string(from: currentWeather.apparentTemperature)
//                Text("Apparent: ")
//                Text(apparenttemp)
//            }
            HStack {
                Text("Cloud covering")
                Text(String(format: "%.0f", currentWeather.cloudCover*100) + "%")
                    .padding(.trailing, 10)
                let wind = weatherManager.windFormatter.string(from: currentWeather.wind.speed)
                Text("Wind Speed: ")
                Text(wind)
            }
//            HStack {
//                let wind = weatherManager.windFormatter.string(from: currentWeather.wind.speed)
//                Text("Wind Speed: ")
//                Text(wind)
//            }
        }
        .font(.footnote)
        .padding(10)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.white).opacity(0.3))
        }
        .padding(.horizontal, 20)
    }
}


//
//  DailyForecastView.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 28.06.24.
//

import SwiftUI
import WeatherKit

struct DailyForecastView: View {
    
    let weatherManager = WeatherManager.shared
    let dailyForecast: Forecast<DayWeather>
    @State private var barWidth: Double = 0
    let timezone: TimeZone
    
    var body: some View {
        Text("Ten day Forecast")
            .font(.title)
            .bold()
        VStack {
            let maxDayTemp = dailyForecast.map { $0.highTemperature.value }.max() ?? 0
            let minDayTemp = dailyForecast.map { $0.lowTemperature.value }.min() ?? 0
            let tempRang = maxDayTemp - minDayTemp
            ForEach(dailyForecast, id:\.date) { day in
                LabeledContent {
                    HStack(spacing: 0) {
                        Image(systemName: day.symbolName)
                            .renderingMode(.original)
                            .symbolVariant(.fill)
                            .font(.system(size: 20))
                        if day.precipitationChance > 0 {
                            Text("\((day.precipitationChance*100).formatted(.number.precision(.fractionLength(0))))%")
                                .font(.system(size: 10))
                                .foregroundStyle(.cyan)
                                .bold()
                        }
                    }
                    .frame(width: 25)
                    Text(weatherManager.temperatureFormatter.string(from: day.lowTemperature))
                        .font(.system(size: 14).weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 50)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(height: 7)
                        .readSize { size in
                            barWidth = size.width
                        }
                        .overlay {
                            let degreeFactor = barWidth / tempRang
                            let dayRangeWidth = (day.highTemperature.value - day.lowTemperature.value)*degreeFactor
                            let xOffset = (day.lowTemperature.value - minDayTemp)*degreeFactor
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(colors: [.green, .orange], startPoint: .leading, endPoint: .trailing))
                                    .frame(width: dayRangeWidth, height: 7)
                                Spacer()
                            }
                            .offset(x: xOffset)
                        }
                    Text(weatherManager.temperatureFormatter.string(from: day.highTemperature))
                        .font(.system(size: 14).weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 50)
                } label: {
                    Text(day.date.localWeekday(for: timezone))
                        .frame(width: 40, alignment: .leading)
                }
                .frame(height: 25)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.secondary.opacity(0.2)))
    }
}


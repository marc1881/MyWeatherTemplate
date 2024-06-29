//
//  BackgroundView.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 27.06.24.
//

import SwiftUI
import WeatherKit

struct BackgroundView: View {
    
    let condition: WeatherCondition
    
    var body: some View {
        Image(condition.rawValue)
            .blur(radius: 5)
            .colorMultiply(.white.opacity(0.8))
    }
}

#Preview {
    BackgroundView(condition: .cloudy)
}

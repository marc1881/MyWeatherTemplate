//
//  LocationDeniedView.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 27.06.24.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        ContentUnavailableView(label: {
            Label("Location Services", systemImage: "gear")
        }, description: {
            Text("""
1. Tap on the Button below to go to "Privacy & Settings"
2. Tap on "Location Services"
3. Locate the "MyWeather" and tap on it
4. Change the Setting to "While using the App"
""")
            .multilineTextAlignment(.leading)
        }, actions: {
            Button {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } label: {
                Text("Open Settings")
            }
        }
        )
    }
}

#Preview {
    LocationDeniedView()
}

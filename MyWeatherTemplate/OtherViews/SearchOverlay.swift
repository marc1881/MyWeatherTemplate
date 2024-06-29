//
//  SearchOverlay.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 28.06.24.
//

import SwiftUI
import MapKit

struct SearchOverlay: View {
    
    @Binding var isSearching: Bool
    @Environment(DataStore.self) private var store
    @State private var searchText = ""
    @FocusState private var isFocused: Bool
    @State private var searchService = SearchService(completer: MKLocalSearchCompleter())
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                    Button {
                        withAnimation {
                            isSearching = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .padding()
                List(searchService.cities) { city in
                    Button {
                        store.cities.append(city)
                        store.saveCities()
                        isSearching = false
                    } label: {
                        Text(city.name)
                            .font(.headline)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onChange(of: searchText) {
            searchService.update(queryFragment: searchText)
        }
        .onAppear {
            searchService.cities = []
            isFocused = true
            searchText = ""
        }
    }
}

#Preview {
    SearchOverlay(isSearching: .constant(true))
        .environment(DataStore(forPreviews: true))
}

//
//  DataStore.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 28.06.24.
//

import Foundation

@Observable
class DataStore {
    var forPreviews: Bool
    var cities: [City] = []
    let fileManager = FileManager()
    
    init(forPreviews: Bool = false) {
        self.forPreviews = forPreviews
        loadCities()
    }
    
    func loadCities() {
        if forPreviews {
            cities = City.cities
        } else {
            if fileManager.fileExists() {
                do {
                    let data = try fileManager.readFile()
                    cities = try JSONDecoder().decode([City].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveCities() {
        if !forPreviews {
            do {
                let data = try JSONEncoder().encode(cities)
                let jsonString = String(decoding: data, as: UTF8.self)
                try fileManager.saveFile(contents: jsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

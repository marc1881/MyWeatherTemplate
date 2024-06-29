//
//  FileManager+Extension.swift
//  MyWeatherTemplate
//
//  Created by Armin Scheithauer on 29.06.24.
//

import Foundation

extension FileManager {
    static var fileName = "Cities.json"
    static var storageUrl = URL.documentsDirectory.appendingPathComponent(fileName, conformingTo: .json)
    
    func fileExists() -> Bool {
        fileExists(atPath: Self.storageUrl.path())
    }
    
    func readFile() throws -> Data {
        do {
            return try Data(contentsOf: Self.storageUrl)
        } catch {
            throw error
        }
    }
    
    func saveFile(contents: String) throws {
        do {
            try contents.write(to: Self.storageUrl, atomically: true, encoding: .utf8)
        } catch {
            throw error
        }
    }
}

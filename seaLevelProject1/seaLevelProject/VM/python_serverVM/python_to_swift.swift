//
//  python_to_swift.swift
//  seaLevelProject
//
//  Created by BEOM SHIEK KANG on 6/13/24.
//

import Foundation
import SwiftUI

import Combine

class MapViewModel: ObservableObject {
    @Published var mapPoints: [MapPoint] = []
    @Published var isLoading: Bool = false

    func fetchMapPoints(for name: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/goSwiftfile?name=\(name)") else {
            return
        }
        
        isLoading = true

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let mapPoints = try JSONDecoder().decode([MapPoint].self, from: data)
                    DispatchQueue.main.async {
                        self.mapPoints = mapPoints
                        self.isLoading = false
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
            } else if let error = error {
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}


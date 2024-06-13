//
//  SeaLevelModel.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/13/24.
//

import SwiftUI
import Combine

class SeaLevelModel: ObservableObject {
    @Published var seaLevel: CGFloat = 0
    
    func fetchSeaLevel(co2: Int) {
        guard let url = URL(string: "http://127.0.0.1:5000/seal?co2=\(co2)") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let result = json["result"] as? CGFloat {
                        DispatchQueue.main.async {
                            self.seaLevel = result / 10 // mm를 cm로 변환
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }.resume()
    }
}

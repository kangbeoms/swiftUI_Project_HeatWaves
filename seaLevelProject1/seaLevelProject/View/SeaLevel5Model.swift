//
//  SeaLevel5Model.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/17/24.
//

import SwiftUI
import Combine

class SeaLevel5Model: ObservableObject {
    @Published var seaLevel: CGFloat = 0
    @Published var temperature: CGFloat = 0

    func fetchSeaLevel(year: Int, carbon: Int) {
        guard let url = URL(string: "http://127.0.0.1:5000/seal5?year=\(year)&carbon=\(carbon)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error with fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let seaLevelResult = json["sealevel_prediction"] as? Double,
                       let tempResult = json["temp_prediction"] as? Double {
                        DispatchQueue.main.async {
                            self.seaLevel = CGFloat(seaLevelResult / 10) // mm를 cm로 변환
                            self.temperature = CGFloat(tempResult) // 온도는 그대로 사용
                        }
                    } else {
                        print("JSON parsing error: unexpected format")
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}






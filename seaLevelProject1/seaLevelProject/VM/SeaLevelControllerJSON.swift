//
//  SeaLevelController.swift
//  HeatWavesSoo
//
//  Created by 김수진 on 6/17/24.
//
import Foundation

class SeaLevelControllerJSON {
    func loadJsonData(url: String) async throws -> [String] {
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // JSON 데이터를 파싱하여 [String] 배열로 반환하는 로직
        let jsonStringArray = try JSONDecoder().decode([String].self, from: data)
        return jsonStringArray
    }
}

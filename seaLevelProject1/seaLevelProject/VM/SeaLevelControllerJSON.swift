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
        let jsonString = String(data: data, encoding: .utf8)
        
        // jsonString을 파싱하여 [String] 배열로 변환
        // 예를 들어, JSON이 ["1.0", "2.0", "3.0"] 형태라면 이를 파싱하여 반환
        let jsonDecoder = JSONDecoder()
        let stringValues = try jsonDecoder.decode([String].self, from: Data(jsonString!.utf8))
        
        return stringValues
    }
}

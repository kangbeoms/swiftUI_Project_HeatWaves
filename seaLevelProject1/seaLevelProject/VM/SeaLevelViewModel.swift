//
//  DataFetcher.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/18/24.
//

import Foundation
import Combine

class SeaLevelViewModel: ObservableObject {
    @Published var seaLevelData: [SeaLevelControllerModel] = []

    func fetchData() {
        guard let url = URL(string: "http://localhost:8080/SwiftUI/JSP/getContVal.jsp?year=2018") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                        DispatchQueue.main.async {
                            self.seaLevelData = self.parseData(jsonArray)
                        }
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }

    private func parseData(_ jsonArray: [String]) -> [SeaLevelControllerModel] {
        let labels = ["연도", "Co2", "인구수", "북극해빙부피", "북극해빙면적평균", "해상평균온도", "지구평균온도"]
        let units = ["(단위:년)", "(단위:mt 메가톤)", "(십억단위)", "(단위:10^12L)", "(단위:10^6Km2)", "(단위:섭씨)", "(단위:섭씨)"]
        var models = [SeaLevelControllerModel]()
        
        for i in 1..<jsonArray.count { // 0번 인덱스는 연도
            if let value = Double(jsonArray[i]) {
                let model = SeaLevelControllerModel(
                    label: labels[i - 1],
                    unit: units[i - 1],
                    value: value,
                    minValue: 0,
                    maxValue: 100
                )
                models.append(model)
            }
        }
        return models
    }
}

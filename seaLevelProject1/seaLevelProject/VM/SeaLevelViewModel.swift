import SwiftUI
import Combine

class SeaLevelViewModel: ObservableObject {
    @Published var seaLevelData: [SeaLevelControllerModel] = []

    func fetchData() {
        // 비동기적으로 데이터를 로드합니다.
        Task {
            do {
                let data = try await self.createSeaLevelControllerData()
                DispatchQueue.main.async {
                    self.seaLevelData = data
                }
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func createSeaLevelControllerData() async throws -> [SeaLevelControllerModel] {
        let labels = ["연도", "Co2", "인구수", "북극해빙부피", "북극해빙면적평균", "해상평균온도", "지구평균온도"]
        let units = ["(단위:년)", "(단위:mt 메가톤)", "(십억단위)", "(단위:10^12L)", "(단위:10^6Km2)", "(단위:섭씨)", "(단위:섭씨)"]
        
        let query = SeaLevelControllerJSON()
        let stringValues: [String] = try await query.loadJsonData(url: "http://localhost:8080/SwiftUI/JSP/getContVal.jsp?year=2018")
        
        // String 배열을 Double 배열로 변환
        let values: [Double] = stringValues.compactMap { Double($0) }
        
        // 만약 변환된 값의 개수가 예상치와 다를 경우 예외 처리
        guard values.count == labels.count else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "데이터 변환 오류"])
        }
        
        let minValues: [Double] = [2019, 0, 0, 0, 0, 0, 0]
        let maxValues: [Double] = [2100, 100000, 100, 100, 100, 100, 100]
        
        var data = [SeaLevelControllerModel]()
        
        for i in 0..<labels.count {
            let item = SeaLevelControllerModel(
                label: labels[i],
                unit: units[i],
                value: values[i],
                minValue: minValues[i],
                maxValue: maxValues[i]
            )
            data.append(item)
        }
        
        return data
    }
}

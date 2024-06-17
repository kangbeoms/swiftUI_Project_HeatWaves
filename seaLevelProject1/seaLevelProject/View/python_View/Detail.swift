//
//  Detail.swift
//  test2_pro
//
//  Created by BEOM SHIEK KANG on 6/17/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Charts

struct Detail: View {
    
    @State private var getData: [DataFrame] = []
    @State private var labels: [String] = ["1990", "2000", "2010", "2018"]
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("기후위기는 더이상 먼 미래가 아닙니다.")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                    
                    Text("홍수, 전 세계를 휩쓴 대형 산불, 감염병의 확산, 가뭄, 폭염 등 기후재앙은 이미 시작되었고 더욱 심해지고 있습니다.")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    // 예측해보기 버튼
                    HStack(spacing: 15){
                        NavigationLink(destination: SeaLevelPredictionView()) {
                            Text("숫자로 해수면 예측")
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                         NavigationLink(destination: AdjustableSeaLevelView()){
                            Text("버튼으로 해수면 예측")
                                .padding(8)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }

                    // 레전드 추가
                    HStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                        Text("해수면 변화")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
                    // 차트
                    Chart(getData, id: \.Year) { tic in
                        LineMark(
                            x: .value("년도", tic.Year),
                            y: .value("해수면", Double(tic.sealevel)!)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(2), Color.blue]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .symbol(.circle)
                        .symbolSize(50)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }
                    .chartXAxis {
                        AxisMarks(values: labels) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let label = value.as(String.self) {
                                    Text(label)
                                        .font(.caption)
                                        .rotationEffect(.degrees(0)) // 레이블을 가로로 배치
                                        .frame(width: 40, alignment: .center)
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                        }
                    }
                    .frame(width: 320, height: 400, alignment: .center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
                    )
                    .padding(.leading, 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                .onAppear {
                    let queryModel = QueryModel()
                    Task {
                        do {
                            getData = try await queryModel.loadData3(url: URL(string: "http://127.0.0.1:5000/getDataFrame")!)
                            print(getData)
                        } catch {
                            print("Failed to load data: \(error)")
                        }
                    }
                }
                .chartXAxisLabel("년도", position: .bottom, alignment: .center)
                .chartYAxisLabel("해수면 (m)", position: .trailing)
            }
        }
    }
}

#Preview {
    Detail()
}

//
//  AdjustableSeaLevelView.swift
//  SeaLevel9
//
//  Created by 기태우 on 6/17/24.
//
import SwiftUI

struct AdjustableSeaLevelView: View {
    @StateObject private var seaLevel5Model = SeaLevel5Model()
    @State private var year: Int = 2024
    @State private var carbon: Int = 10355

    var body: some View {
        VStack {
            ZStack {
                // y축 눈금 표시
                YAxisView()
                    .frame(height: 400)

                // 해수면
                SeaLevelShape(seaLevel: seaLevel5Model.seaLevel)
                    .fill(Color.blue.opacity(1))
                    .frame(height: 400)

                // 집 아이콘
                Image("family")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 360) // 5m 높이
                    .offset(y: 110) // 집 아이콘을 해수면 위로 배치하기 위해 offset 사용
            }
            .frame(height: 400)

            Spacer()

            // 조정 버튼 및 예측 버튼
            VStack(spacing: 16) {
                HStack {
                    Button(action: {
                        year -= 1
                        seaLevel5Model.fetchSeaLevel(year: year, carbon: carbon)
                    }) {
                        Text("-")
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    Text("연도: \(year)")
                        .padding()
                    Button(action: {
                        year += 1
                        seaLevel5Model.fetchSeaLevel(year: year, carbon: carbon)
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }

                HStack {
                    Button(action: {
                        carbon -= 1000
                        seaLevel5Model.fetchSeaLevel(year: year, carbon: carbon)
                    }) {
                        Text("-")
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                    Text("탄소 배출량: \(carbon) MtC")
                        .padding()
                    Button(action: {
                        carbon += 1000
                        seaLevel5Model.fetchSeaLevel(year: year, carbon: carbon)
                    }) {
                        Text("+")
                            .font(.largeTitle)
                            .frame(width: 50, height: 50)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(25)
                    }
                }
            }
            .padding()
            // 해수면 변화 예측 텍스트
            Text("해수면 변화 예측: \(seaLevel5Model.seaLevel, specifier: "%.2f")cm")
                .padding()

            // 온도 변화 텍스트
            Text("평균 온도 증감 예측: \(seaLevel5Model.temperature, specifier: "%.2f")°C")
                .padding()
        }
    }
}

struct AdjustableSeaLevelView_Previews: PreviewProvider {
    static var previews: some View {
        AdjustableSeaLevelView()
    }
}

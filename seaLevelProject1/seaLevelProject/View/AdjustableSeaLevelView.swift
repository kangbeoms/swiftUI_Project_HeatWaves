//
//  AdjustableSeaLevelView.swift
//  seaLevelProject
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
            Spacer().frame(height:12)
            ZStack {
                // y축 눈금 표시
                YAxisView()
                    .frame(height: 500)

                // 해수면
                SeaLevelShape(seaLevel: seaLevel5Model.seaLevel)
                    .fill(Color.blue.opacity(1))
                    .frame(height: 500)

                // 집 아이콘
                Image("family")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 360) // 5m 높이
                    .offset(y: 160) // 집 아이콘을 해수면 위로 배치하기 위해 offset 사용
            }
            .frame(height: 500)

            // 조정 버튼 및 예측 버튼
            VStack(spacing: 1) {
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
                            .padding(2)
                    }
                    Text("연도: \(year)")
                        .padding(8)
                        .font(.system(size: 16)) // 글꼴 크기를 줄임
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
                            .padding(1)
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
                            .padding(1)
                    }
                    Text("탄소 배출량: \(carbon) MtC")
                        .padding(1)
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
                            .padding(1)
                    }
                }
            }
            .padding(1)
            // 해수면 변화 예측 텍스트
            Text("해수면 변화 예측: \(seaLevel5Model.seaLevel, specifier: "%.2f")cm")
                .padding(1)
                .font(.system(size: 16)) // 글꼴 크기를 줄임
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)

            // 온도 변화 텍스트
            Text("평균 온도 증감 예측: \(seaLevel5Model.temperature, specifier: "%.2f")°C")
                .padding(1)
                .font(.system(size: 16)) // 글꼴 크기를 줄임
                .foregroundColor(.red)
        }
    }
}

struct AdjustableSeaLevelView_Previews: PreviewProvider {
    static var previews: some View {
        AdjustableSeaLevelView()
    }
}


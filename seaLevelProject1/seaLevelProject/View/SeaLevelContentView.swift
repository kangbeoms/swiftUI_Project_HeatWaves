//
//  SeaLevelContentView.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/13/24.
//

import SwiftUI


struct SeaLevelContentView: View {
    @StateObject private var seaLevelModel = SeaLevelModel()
    @State private var co2Input: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                // y축 눈금 표시
                YAxisView()
                    .frame(height: 700)
                
                // 해수면
                SeaLevelShapeView(seaLevel: seaLevelModel.seaLevel)
//                    .fill(Color.blue.opacity(0.5))
                
                    .fill(Color.blue.opacity(1))
                    .frame(height: 700)
                
                // 집 아이콘
                Image("house_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 560) // 5m 높이
                    .offset(y: 190) // 집 아이콘을 해수면 위로 배치하기 위해 offset 사용
            }
            .frame(height: 700)

            Spacer()

            // CO2 입력 필드 및 버튼
            HStack {
                TextField("탄소배출량 입력(단위 MtC)", text: $co2Input)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if let co2 = Int(co2Input) {
                        seaLevelModel.fetchSeaLevel(co2: co2)
                    }
                }) {
                    Text("해수면 예측")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}





struct SeaLevelContentView_Previews: PreviewProvider {
    static var previews: some View {
        SeaLevelContentView()
    }
}



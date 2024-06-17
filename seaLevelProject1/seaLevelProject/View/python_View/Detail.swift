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
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    ZStack {
                        Text("기후위기는 더이상 먼 미래가 아닙니다.")
                            .font(.system(size: 40))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 30)
                    }
                    
                    Text("홍수, 전 세계를 휩쓴 대형 산불, 감염병의 확산, 가뭄, 폭염 등 기후재앙은 이미 시작되었고 더욱 심해지고 있습니다.")
                        .font(.body)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Chart(getData, id: \.Year) { tic in
                        LineMark(
                            x: .value("년도", tic.Year),
                            y: .value("해수면", Double(tic.sealevel)!)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.blue)
                        .symbol(.circle)
                    }
                    .chartXAxis {
                        AxisMarks(values: labels)
                    }
                    .frame(width: 300, height: 340)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
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
            .chartXAxisLabel {
                Text("년도")
                    .font(.caption)
                    .padding(.top, 20)
            }
            .chartYAxisLabel("해수면 (m)", position: .leading)
        }
    }
}


#Preview {
    Detail()
}

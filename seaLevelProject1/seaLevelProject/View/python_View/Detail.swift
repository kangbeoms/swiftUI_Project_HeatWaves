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
    
    @State var getData: [DataFrame] = []
    @State var labels: [String] = ["1990","2000","2010"]
    var body: some View {
        ScrollView{
            VStack {
                //            Image("")
                //                .resizable()
                //                .aspectRatio(contentMode: .fill)
                //                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 10) {
                    ZStack{
                        
                        
                        Text("기후위기는 더이상 먼 미래가 아닙니다.")
                            .font(.system(size: 40))
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 30)
                    }
                    
                    Text("홍수, 전 세계를 휩쓴 대형 산불, 감염병의 확산, 가뭄, 폭염 등 기후재앙은" +
                         "이미 시작되었고 더욱 심해지고 있습니다.")
                    .font(.body)
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Chart(getData,id: \.Year){ tic in
                        LineMark(x: .value("년도", tic.Year), y: .value("해수면", tic.sealevel)
                        )
                        .interpolationMethod(.catmullRom)
                                    .foregroundStyle(.blue)
                                    .symbol(.circle)
                    }
                    .chartXAxis {
                                  AxisMarks(values: getData.map { $0.Year })
                              }
                              .chartYAxis {
                                  AxisMarks(values: Array(stride(from: 1.0, through: 2.0, by: 0.1)))
                              }
                    .frame(width: 300,height: 340)
                    .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding()
             
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .onAppear(perform: {
                let queryModel = QueryModel()
                Task {
                    getData = try await queryModel.loadData3(url: URL(string: "http://127.0.0.1:5000/getDataFrame")!)
                    print(getData)
                    
                }
            })
        }
        
    }
}


#Preview {
    Detail()
}

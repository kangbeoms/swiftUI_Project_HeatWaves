//
//  SeaLevelControllView.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/13/24.
//

import SwiftUI

struct SeaLevelControllView: View {    
//    @EnvironmentObject private var vm: FeaturesViewModel
    @State private var seaLevel: CGFloat = 0 // 해수면 높이 초기값
    @State private var co2Val: CGFloat = 0.0
    @State private var popVal: CGFloat = 0.0
    @State private var thicVal: CGFloat = 0.0
    @State private var thicMeanVal: CGFloat = 0.0
    @State private var seaMeanTempVal: CGFloat = 0.0
    @State private var seaSurMeanTempVal: CGFloat = 0.0
    @State private var earthTempMeanVal: CGFloat = 0.0
    
    var body: some View {
        VStack (spacing: 16){
            Spacer()
            chartSection
            Spacer()
//            controlSection
//            Spacer()
            
        }//VStack
    }
}

struct SeaLevelControllView_Previews: PreviewProvider {
    static var previews: some View {
        SeaLevelControllView()
    }
}

extension SeaLevelControllView {
    // 해수면 그래프 올라가는 부분
    private var chartSection: some View{
        ZStack(content: {
            // y축 눈금 표시
            YAxisView()
                .frame(height: 300)
            
            // 해수면
            SeaLevelShapeView(seaLevel: seaLevel)
                .fill(Color.blue.opacity(0.5))
                .frame(height: 300)
        
            // 집 아이콘
            Image("house_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 500) // 5m 높이
                .offset(y: 60) // 집 아이콘을 해수면 위로 배치하기 위해 offset 사용
        })
        .frame(width: 300, height: 300)
        .padding(6)
        .background(Color.red)
    }
    
    // 해수면에 영향을 미치는 요소들을 조정하는 부분
    private var controlSection: some View{
        showCo2ControllerView

    }
    private var showCo2ControllerView: some View {
        VStack {    // title
            controlLabelSection
            HStack {    // Control Button
                Spacer()
                leftButtonSection
                tfAmount
                rightButtonSection
                Spacer()
            }
        }
    }//setControl
    
    private var controlLabelSection: some View{
        Text("Co2 (단위:mt 메가톤)")
            .font(.system(size: 10, weight: .bold))
    }//controlLabelSection
    
    private var tfAmount: some View{
        TextField(0, text: String($co2Val))
            .textFieldStyle(.roundedBorder)
            .frame(width: 50)
            .multilineTextAlignment(.trailing)
            .keyboardType(.numberPad)
    }//tfAmount
    
    private var rightButtonSection: some View{
        Button(action: {
            if seaLevel > 0 { // 최소 높이 제한
                seaLevel -= 5
            }
        }) {
            Text(">")
                .font(.system(size:10, weight: .regular))
                .frame(width: 20, height: 20)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(25)
        }
    }//rightButtonSection
    
    private var leftButtonSection: some View{
        Button(action: {
            if seaLevel < 300 { // 최대 높이 제한
                seaLevel += 5
            }
        }) {
            Text("<")
                .font(.system(size:10, weight: .regular))
                .frame(width: 20, height: 20)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(25)
        }
    }//leftButtonSection
}

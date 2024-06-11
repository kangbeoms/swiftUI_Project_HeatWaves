//
//  ContentView.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/11/24.
//
import SwiftUI

struct ContentView: View {
    @State private var seaLevel: CGFloat = 0 // 해수면 높이 초기값

    var body: some View {
        VStack {
            ZStack {
                // y축 눈금 표시
                YAxisView()
                    .frame(height: 700)
                
                // 해수면
                SeaLevelShape(seaLevel: seaLevel)
                    .fill(Color.blue.opacity(0.5))
                    .frame(height: 700)
                
                // 집 아이콘
//                HouseShape()
//                    .fill(Color.gray)
//                    .frame(width: 100, height: 250) // 5m 높이
//                    .offset(y: 225) // 집 아이콘을 해수면 위로 배치하기 위해 offset 사용
//            }
//            .frame(height: 700)
            
            // 집 아이콘
            Image("house_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 600) // 5m 높이
                .offset(y: 250) // 집 아이콘을 해수면 위로 배치하기 위해 offset 사용
        }
        .frame(height: 700)

            Spacer()

            // 탭바 버튼
            HStack {
                Button(action: {
                    if seaLevel < 700 { // 최대 높이 제한
                        seaLevel += 5
                    }
                }) {
                    Text("+")
                        .font(.largeTitle)
                        .frame(width: 50, height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }

                Spacer()

                Button(action: {
                    if seaLevel > 0 { // 최소 높이 제한
                        seaLevel -= 5
                    }
                }) {
                    Text("-")
                        .font(.largeTitle)
                        .frame(width: 50, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
    }
}

//struct HouseShape: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let roofHeight = rect.height / 3
//        let bodyHeight = rect.height * 2 / 3
//        
//        // 지붕
//        path.move(to: CGPoint(x: rect.midX, y: 0))
//        path.addLine(to: CGPoint(x: rect.maxX, y: roofHeight))
//        path.addLine(to: CGPoint(x: rect.minX, y: roofHeight))
//        path.addLine(to: CGPoint(x: rect.midX, y: 0))
//        
//        // 본체
//        path.move(to: CGPoint(x: rect.minX, y: roofHeight))
//        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: roofHeight))
//        path.addLine(to: CGPoint(x: rect.minX, y: roofHeight))
//        
//        // 창문
//        let windowWidth = rect.width / 5
//        let windowHeight = bodyHeight / 5
//        
//        // 왼쪽 창문
//        let leftWindowRect = CGRect(x: rect.minX + windowWidth, y: roofHeight + windowHeight, width: windowWidth, height: windowHeight)
//        path.addRect(leftWindowRect)
//        
//        // 오른쪽 창문
//        let rightWindowRect = CGRect(x: rect.maxX - 2 * windowWidth, y: roofHeight + windowHeight, width: windowWidth, height: windowHeight)
//        path.addRect(rightWindowRect)
//        
//        // 문
//        let doorWidth = rect.width / 5
//        let doorHeight = bodyHeight / 2
//        let doorRect = CGRect(x: rect.midX - doorWidth / 2, y: rect.maxY - doorHeight, width: doorWidth, height: doorHeight)
//        path.addRect(doorRect)
//        
//        return path
//    }
//}

struct SeaLevelShape: Shape {
    var seaLevel: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let adjustedSeaLevel = rect.maxY - seaLevel
        path.move(to: CGPoint(x: rect.minX, y: adjustedSeaLevel))
        path.addLine(to: CGPoint(x: rect.maxX, y: adjustedSeaLevel))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct YAxisView: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<701) { index in
                if index % 10 == 0 {
                    Text("\(index)mm")
                        .font(.caption)
                        .position(x: 20, y: geometry.size.height - CGFloat(index))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

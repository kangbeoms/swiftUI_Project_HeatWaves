import SwiftUI

struct SeaLevelChartView: View {
    @Binding var landmark: LandMarkListModel
    @ObservedObject var viewModel: SeaLevelViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ZStack(alignment: .bottom) { // 아래에서 시작하도록 설정
                    // y축 눈금 표시
                    SeaLevelChartYAxisView()
                        .frame(height: 500)
                    
                    // 해수면
                    SeaLevelChartShapeView(seaLevel: viewModel.seaLevelValue)
                        .fill(Color.blue.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .bottom)
                    
                    // 집 아이콘
                    Image("house_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150) // 아이콘의 크기를 조정
//                        .offset(y: -viewModel.seaLevelValue * 10) // 집 아이콘을 해수면 위로 배치
                }
                .frame(width: 300, height: 500) // 기본값을 설정
//                .background(Color.red)
                .padding(6)
                .id("bottom") // 태그 지정
            }
            .padding()
            .onAppear {
                proxy.scrollTo("bottom", anchor: .bottom) // 태그 위치로 스크롤
            }
        }
    }

    func stringToCGFloat(_ stringValue: String) -> CGFloat? {
        if let doubleValue = Double(stringValue) {
            return CGFloat(doubleValue)
        } else {
            return nil
        }
    }
}

struct SeaLevelChartView_Previews: PreviewProvider {
    static var previews: some View {
        SeaLevelChartView(landmark: .constant(LandMarkListModel(name: "롯데타워", sealevel: "14", height: "555")), viewModel: SeaLevelViewModel())
    }
}

@@ -9,90 +9,122 @@ import SwiftUI

struct SeaLevelContentView: View {
    @State private var seaLevel: CGFloat = 0 // 해수면 높이 초기값

    @State var firstNum = ""
    @State var secondNum = ""
    
//    let feature: FeatureModel
    
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
                Image("house_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 600) // 5m 높이
                    .offset(y: 250) // 집 아이콘을 해수면 위로 배치하기 위해 offset 사용
            }
            .frame(height: 700)

        VStack (spacing: 16){
            Spacer()
            chartSection
            Spacer()
            controlSection
            Spacer()
            
        }//VStack
        
    }//body
}//SealevelView

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
struct SeaLevelContentView_Previews: PreviewProvider {
    static var previews: some View {
        SeaLevelContentView()
//        SealevelView(feature:
//                        FeatureDataService.features.first!)
//                        .environmentObject(FeatureModel())
//
    }
}

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
extension SealevelView {
    // 해수면 그래프 올라가는 부분
    private var chartSection: some View{
        ZStack(content: {
            // y축 눈금 표시
            YAxisView()
                .frame(height: 300)
            
            // 해수면
            SeaLevelShape(seaLevel: seaLevel)
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
    
    // 해수면에 영향을 미치는 요소들을 조정하는 부분
    private var controlSection: some View{
        
//        ForEach(numList){
            setControl
//        }
    }
    
    private var setControl: some View {
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
    }
    }//setControl
    
    private var controlLabelSection: some View{
        Text("Co2 (단위:mt 메가톤)")
            .font(.system(size: 10, weight: .bold))
    }//controlLabelSection
    
    private var tfAmount: some View{
        TextField("0", text: $secondNum)
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

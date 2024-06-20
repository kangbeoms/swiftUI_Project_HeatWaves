import SwiftUI

struct SeaLevelView: View {
    @Binding var landmark: LandMarkListModel
    @StateObject var viewModel = SeaLevelViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                SeaLevelChartView(landmark: $landmark, viewModel: viewModel)
                    .frame(height: geometry.size.height / 2)
                SeaLevelListView(viewModel: viewModel)
                    .frame(height: geometry.size.height / 2)
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

#Preview {
    SeaLevelView(landmark: .constant(LandMarkListModel(name: "롯데타워", sealevel: "14", height: "555")))
}

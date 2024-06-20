import SwiftUI

struct SeaLevelListView: View {
    @StateObject var viewModel = SeaLevelViewModel()
    
    var body: some View {
        VStack {
            if viewModel.seaLevelData.isEmpty {
                Text("Loading data...")
                    .onAppear {
                        viewModel.fetchData()
                    }
            } else {
                List {
                    ForEach($viewModel.seaLevelData) { $item in
                        SeaLevelItemView(item: $item, viewModel: viewModel)
                    }
                }
            }
        }
    }
}

struct SeaLevelItemView: View {
    @Binding var item: SeaLevelControllerModel
    @ObservedObject var viewModel: SeaLevelViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(item.label)
                        .font(.headline)
                    Text(item.unit)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Stepper(value: $item.value, in: item.minValue...item.maxValue, step: item.step) {
                    Text("\(Int(item.value))")  // 정수 형태로 값을 표시
                        .font(.subheadline)
                }
                .onChange(of: item.value) { newValue in
                    // 각 값을 업데이트하고 fetchSeaLevelValue 호출
                    viewModel.fetchSeaLevelValue(
                        year: 2023,
                        co2: viewModel.seaLevelData[1].value,
                        population: viewModel.seaLevelData[2].value,
                        thickness: viewModel.seaLevelData[3].value,
                        area: viewModel.seaLevelData[4].value,
                        seaTemp: viewModel.seaLevelData[5].value,
                        globalTemp: viewModel.seaLevelData[6].value
                    )
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct SeaLevelListView_Previews: PreviewProvider {
    static var previews: some View {
        SeaLevelListView()
    }
}

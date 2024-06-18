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
                        SeaLevelItemView(item: $item)
                    }
                }
            }
        }
    }
}

struct SeaLevelItemView: View {
    @Binding var item: SeaLevelControllerModel
    
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
                Stepper(value: $item.value, in: item.minValue...item.maxValue, step: 1) {
                    Text("\(item.value, specifier: "%.2f")")
                        .font(.subheadline)
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

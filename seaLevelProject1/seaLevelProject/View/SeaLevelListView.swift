//
//  SeaLevelListView.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/18/24.
//

struct SeaLevelListView: View {
    @ObservedObject var dataFetcher = DataFetcher()
    
    var body: some View {
        VStack {
            if dataFetcher.seaLevelData.isEmpty {
                Text("Loading data...")
                    .onAppear {
                        dataFetcher.fetchData()
                    }
            } else {
                List {
                    ForEach(dataFetcher.seaLevelData) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.label)
                                    .font(.headline)
                                Text("\(item.value, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(item.unit)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
        }
    }
}

struct SeaLevelListView_Previews: PreviewProvider {
    static var previews: some View {
        SeaLevelListView()
    }
}

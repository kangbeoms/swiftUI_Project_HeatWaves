//
//  SeaLevelListView.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/18/24.
//
import SwiftUI

struct SeaLevelListView: View {
    @ObservedObject var viewModel = SeaLevelViewModel()
    
    var body: some View {
        VStack {
            if viewModel.seaLevelData.isEmpty {
                Text("Loading data...")
                    .onAppear {
                        viewModel.fetchData()
                    }
            } else {
                List {
                    ForEach(viewModel.seaLevelData) { item in
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

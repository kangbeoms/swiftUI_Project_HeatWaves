//
//  ContentView.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Text("dsa")
        SeaLevelListView(data: SeaLevelListModel(label: "1", unit: "2", value: 1,minValue: 0, maxValue: 100))
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


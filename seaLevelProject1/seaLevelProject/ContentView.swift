//
//  ContentView.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/11/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
//        MainView()
//        SeaLevelListView()
        SeaLevelChartView(landmark: .constant(LandMarkListModel(name: "롯데타워", sealevel: "14", height: "555")))
//        TabView {
//            SeaLevelPredictionView()
//                .tabItem {
//                    Label("SeaLevel1", systemImage: "house")
//                }
//
//            AdjustableSeaLevelView()
//                .tabItem {
//                    Label("SeaLevel2", systemImage: "person.3.fill")
//                }
//        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


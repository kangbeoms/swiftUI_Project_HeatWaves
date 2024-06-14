//
//  FeaturesView.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/14/24.
//

import SwiftUI
class FeaturesViewModel: ObservableObject{
    @Published var features: [FeatureDataModel]
    
    init(){
        let features = FeatureDataService.features
        self.features = features
    }
}
struct FeaturesView: View {
    
    @StateObject private var vm = FeaturesViewModel()
    
    var body: some View {
        List{
            ForEach(vm.features){
                
            }
        }
    }
}

#Preview {
    FeaturesView()
}

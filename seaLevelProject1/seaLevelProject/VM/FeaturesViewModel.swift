//
//  FeaturesViewModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/14/24.
//

import Foundation

class FeaturesViewModel: ObservableObject{
    @Published var featureDataModels: [FeatureDataModel]
    
    init(){
        let featureDataModels = FeatureDataService.featureDataModels
        self.featureDataModels = featureDataModels
    }
}

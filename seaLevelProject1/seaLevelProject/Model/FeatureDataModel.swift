//
//  FeatureModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/12/24.
//

import Foundation

struct FeatureDataModel: Identifiable{
//    let id = UUID().uuidString
    let feature: String
    let label: String
    let amount: Double
    
    var id: String{
        feature
    }
}

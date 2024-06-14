//
//  FeatureModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/14/24.
//

import Foundation

struct FeatureModel: Identifiable{
    let id = UUID().uuidString
    let label: String
    let amount: Double
    
}

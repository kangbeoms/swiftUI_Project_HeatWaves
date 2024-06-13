//
//  FeatureModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/12/24.
//

import Foundation

struct FeatureDataModel: Decodable{
    var label: String
    var amount: String
    
    init(label: String, amount: String) {
        self.label = label
        self.amount = amount
    }
}

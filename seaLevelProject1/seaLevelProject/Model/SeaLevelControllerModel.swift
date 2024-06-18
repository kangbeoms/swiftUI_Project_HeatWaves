//
//  SeaLevelControllerModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/18/24.
//

import Foundation

struct SeaLevelControllerModel: Identifiable {
    var id = UUID()
    var label: String
    var unit: String
    var value: Double
    var minValue: Double
    var maxValue: Double
}

//
//  SeaLevelControllerModel.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/18/24.
//

import Foundation

struct SeaLevelControllerModel: Identifiable {
    let id = UUID()
    var label: String
    var unit: String
    var value: Double
    var minValue: Double
    var maxValue: Double

    init(label: String, unit: String, value: Double, minValue: Double = 0, maxValue: Double = 100) {
        self.label = label
        self.unit = unit
        self.value = value
        self.minValue = minValue
        self.maxValue = maxValue
    }
}

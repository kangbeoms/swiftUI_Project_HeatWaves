//
//  SeaLevelShapeView.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/13/24.
//

import SwiftUI

struct SeaLevelShapeView: Shape {
    var seaLevel: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let adjustedSeaLevel = rect.maxY - seaLevel
        path.move(to: CGPoint(x: rect.minX, y: adjustedSeaLevel))
        path.addLine(to: CGPoint(x: rect.maxX, y: adjustedSeaLevel))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


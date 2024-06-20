//
//  SeaLevelChartShapeView.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/19/24.
//

import SwiftUI

struct SeaLevelChartShapeView: Shape {
    var seaLevel: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY - seaLevel))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - seaLevel))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

//
//  111111.swift
//  seaLevelProject
//
//  Created by 기태우 on 6/13/24.
//

import SwiftUI

struct YAxisView: View {
    var body: some View {
        GeometryReader { geometry in
            ForEach(0..<501) { index in
                if index % 10 == 0 {
                    Text("\(index)cm")
                        .font(.caption)
                        .position(x: 25, y: geometry.size.height - CGFloat(index))
                }
            }
        }
    }
}


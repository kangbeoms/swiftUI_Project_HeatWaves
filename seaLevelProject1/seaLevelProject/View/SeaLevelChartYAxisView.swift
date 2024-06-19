//
//  SeaLevelChartYAxisView.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/19/24.
//

import SwiftUI

struct SeaLevelChartYAxisView: View {
    var body: some View {
        VStack {
            ForEach((0..<10).reversed(), id: \.self) { i in
                Text("\(i * 10)m")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 30)
                Spacer()
            }
        }
        .frame(width: 50)
    }
}

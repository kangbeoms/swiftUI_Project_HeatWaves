//
//  StepperView.swift
//  seaLevelProject
//
//  Created by 김수진 on 6/15/24.
//

import SwiftUI

struct StepperView: View {
    @State var stepperTitle: String = "[항목]"
    @State var stepperValue: Int = 10
    
    var body: some View {
        Stepper("\(stepperTitle): \(stepperValue)", value: $stepperValue)
    }
}

#Preview {
    StepperView()
}

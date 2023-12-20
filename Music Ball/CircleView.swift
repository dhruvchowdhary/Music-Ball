//
//  CircleView.swift
//  Music Ball
//
//  Created by Dhruv Chowdhary on 12/18/23.
//

import SwiftUI

struct CircleView: View {
    let circleDiameter: CGFloat = 320
    var circleRadius: CGFloat {
        circleDiameter / 2
    }
    let circleCenter = CGPoint(x: 180, y: 350)
    
    @Binding var resetFlag: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.accentColor, lineWidth: 4) // Adjust the line width as needed
//                .position(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
                .frame(width: circleDiameter, height: circleDiameter) // Adjust the size of the circle as needed
            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 100, y: 293), color: Color.red, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag)
        }
    }
}

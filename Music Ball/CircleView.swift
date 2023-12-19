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
    
    @Binding var resetFlag: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.accentColor, lineWidth: 4) // Adjust the line width as needed
//                .position(CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
                .frame(width: circleDiameter, height: circleDiameter) // Adjust the size of the circle as needed
            BallView(gravity: 1, damping: 1.05, diameter: 20, position: CGPoint(x: 100, y: 363), lrgCircleRadius: circleRadius, lrgCircleCenter: CGPoint(x: 180, y: 350), resetFlag: $resetFlag)
//            BallView(gravity: -1, damping: 0.7, lrgCircleRadius: circleRadius, lrgCircleCenter: CGPoint(x: 180, y: 363))
        }
    }
}

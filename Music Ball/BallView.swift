//
//  BallView.swift
//  Music Ball
//
//  Created by Dhruv Chowdhary on 12/18/23.
//

import SwiftUI

struct BallView: View {
    @State private var ballPosition: CGPoint
    var initialBallPosition: CGPoint
    @State private var ballVelocity = CGVector(dx: 0, dy: 0)
    var gravity: CGFloat
    var damping: CGFloat
    var diameter: CGFloat
    var lrgCircleRadius: CGFloat
    var lrgCircleCenter: CGPoint
    @Binding var resetFlag: Bool

    init(gravity: CGFloat, damping: CGFloat, diameter: CGFloat, position: CGPoint, lrgCircleRadius: CGFloat, lrgCircleCenter: CGPoint, resetFlag: Binding<Bool>) {
        self.gravity = gravity
        self.damping = damping
        self.diameter = diameter
        _ballPosition = State(initialValue: position)
        self.lrgCircleRadius = lrgCircleRadius
        self.lrgCircleCenter = lrgCircleCenter
        _resetFlag = resetFlag
        self.initialBallPosition = position
    }

    var body: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: diameter, height: diameter)
            .position(ballPosition)
            .onAppear {
                // Add animation for the falling effect
                let animation = Animation.linear(duration: 2.0)
                withAnimation(animation) {
                    updateBallPosition()
                }
            }
            .onChange(of: resetFlag) { newValue in
                            // Reset the ball position when resetFlag changes
                            ballPosition = initialBallPosition
                            ballVelocity = CGVector(dx: 0, dy: 0)
                let animation = Animation.linear(duration: 2.0)
                withAnimation(animation) {
                    updateBallPosition()
                }
                        }
    }

    private func updateBallPosition() {
        // Update ball position and velocity based on gravity
        let timeStep = 0.1
        let acceleration = CGVector(dx: 0, dy: gravity)
        ballVelocity = CGVector(dx: ballVelocity.dx + acceleration.dx * CGFloat(timeStep), dy: ballVelocity.dy + acceleration.dy * CGFloat(timeStep))
        ballPosition = CGPoint(x: ballPosition.x + ballVelocity.dx * CGFloat(timeStep), y: ballPosition.y + ballVelocity.dy * CGFloat(timeStep))

        // Check for collision with the edge of the large circle
        var distanceToCenter = ballPosition.distance(to: lrgCircleCenter)
//        print("distanceToCenter: \(distanceToCenter)")
//        print("Bounce - Position: \(ballPosition), Velocity: \(ballVelocity)")
        if distanceToCenter >= lrgCircleRadius - 10 {
            // Calculate the normal vector of the collision point
            let normalVector = CGVector(dx: lrgCircleCenter.x - ballPosition.x, dy: lrgCircleCenter.y - ballPosition.y)

            // Calculate the dot product of the normal vector and the velocity vector
            let dotProduct = (ballVelocity.dx * normalVector.dx + ballVelocity.dy * normalVector.dy)

            // Calculate the new velocity based on the normal vector
            ballVelocity = CGVector(
                dx: ballVelocity.dx - 2 * dotProduct * normalVector.dx / (normalVector.dx * normalVector.dx + normalVector.dy * normalVector.dy),
                dy: ballVelocity.dy - 2 * dotProduct * normalVector.dy / (normalVector.dx * normalVector.dx + normalVector.dy * normalVector.dy)
            )

            // Apply damping to the new velocity
            ballVelocity = CGVector(dx: ballVelocity.dx * damping, dy: ballVelocity.dy * damping)

            // Move the ball slightly away from the collision point to avoid sticking to the edge
            ballPosition = CGPoint(x: ballPosition.x + ballVelocity.dx * CGFloat(timeStep), y: ballPosition.y + ballVelocity.dy * CGFloat(timeStep))

            // Recalculate the distance to the center after the bounce
            distanceToCenter = ballPosition.distance(to: lrgCircleCenter)
        }

        // Repeat the update until the ball is out of the screen or reaches a specific condition
        if distanceToCenter <= lrgCircleRadius {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                updateBallPosition()
            }
        }
    }
}

// Extension to calculate distance between two CGPoint
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}

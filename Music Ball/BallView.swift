//
//  BallView.swift
//  Music Ball
//
//  Created by Dhruv Chowdhary on 12/18/23.
//

import SwiftUI
import AVFoundation

struct BallView: View {
    @State private var ballPosition: CGPoint
    var initialBallPosition: CGPoint
    @State private var ballVelocity = CGVector(dx: 0, dy: 0)
    var gravity: CGFloat
    var damping: CGFloat
    var diameter: CGFloat
    var color: Color
    var lrgCircleRadius: CGFloat
    var lrgCircleCenter: CGPoint
    @State private var timeStep = 0.5
    @State private var originalTimeStep = 0.5
    @State private var firstBounce = true
    var songNotes = ["f4", "f4", "d4", "a4", "d4", "f4", "d4", "a4", "d4", "f4", "c4", "a4", "c4", "f4", "c4", "a4", "c4", "e4", "c-4", "a4", "c-4", "e4", "c-4", "a4", "c-4", "e4", "c-4", "a4", "c-4", "e4", "c-4", "a5", "d4", "e4", "f4", "a5", "g4", "a5", "c4", "d4", "e4", "f4", "e4", "g4", "a5", "g4", "f4", "f4", "f4", "f4", "a5", "a5", "g4", "f4", "a5", "a5", "a5", "g4", "a5", "g4", "f4", "f4", "f4", "f4", "a5", "a5", "g4", "f4", "a5", "a5", "a5", "c-5", "c-5", "c-5", "f4", "f4", "f4", "a5", "a5", "g4", "f4", "a-5", "a-5", "a-5", "g4", "c5", "a5", "c-5", "f4", "d4", "f4", "a5", "e4", "c-4", "a5", "c-5", "d5", "d3"]
//    var noteLength = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 6, 2, 8, 3, 3, 2, 8, 6, 2, 4, 4, 4, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4]
    var noteLength = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 6, 2, 8, 3, 3, 2, 8, 6, 2, 4, 4, 4, 4, 4, 5, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4,1,1,1,1,1,1,1,1,4,4]
    @State private var noteCount = 0
    @State private var orginalVelocity = CGVector(dx: 0, dy: 1) // Velocity without the noteLength
    
    @Binding var resetFlag: Bool
    
    @State private var audio: AVPlayer?

    init(gravity: CGFloat, damping: CGFloat, diameter: CGFloat, position: CGPoint, color: Color, lrgCircleRadius: CGFloat, lrgCircleCenter: CGPoint, resetFlag: Binding<Bool>) {
        self.gravity = gravity
        self.damping = damping
        self.diameter = diameter
        _ballPosition = State(initialValue: position)
        self.color = color
        self.lrgCircleRadius = lrgCircleRadius
        self.lrgCircleCenter = lrgCircleCenter
        _resetFlag = resetFlag
        self.initialBallPosition = position
    }

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: diameter, height: diameter)
            .position(ballPosition)
            .onAppear {
                // Add animation for the falling effect
                initiateAnimation()
            }
            .onChange(of: resetFlag) { newValue in
                // Reset the ball position when resetFlag changes
                ballPosition = initialBallPosition
                ballVelocity = CGVector(dx: 0, dy: 0)
                firstBounce = true
                noteCount = 0
                initiateAnimation()
            }
    }
    
    private func initiateAnimation() {
        let animation = Animation.linear(duration: 2.0)
        withAnimation(animation) {
            updateBallPosition()
        }
    }
    
    func playSound() {
        // need to declare local path as url
        guard let folderPath = Bundle.main.path(forResource: "mp3Notes", ofType: nil) else {
                // Handle the case where the folder path is not found
                return
            }
        let filePath = URL(fileURLWithPath: folderPath).appendingPathComponent(songNotes[noteCount]).appendingPathExtension("mp3")
        // now use declared path 'url' to initialize the player
        audio = AVPlayer.init(url: filePath)
        // after initialization play audio its just like click on play button
        audio?.play()
        noteCount += 1
    }
    
    private func handleCollision() {
        // Calculate the normal vector of the collision point
        let normalVector = CGVector(dx: lrgCircleCenter.x - ballPosition.x, dy: lrgCircleCenter.y - ballPosition.y)
        
        // Set original velocity for the first bounce
        if firstBounce {
            orginalVelocity = ballVelocity
            originalTimeStep = timeStep
        }

        // Calculate the dot product of the normal vector and the velocity vector
        let dotProduct = (orginalVelocity.dx * normalVector.dx + orginalVelocity.dy * normalVector.dy)

        // Calculate the new velocity based on the normal vector
        ballVelocity = CGVector(
            dx: orginalVelocity.dx - 2 * dotProduct * normalVector.dx / (normalVector.dx * normalVector.dx + normalVector.dy * normalVector.dy),
            dy: orginalVelocity.dy - 2 * dotProduct * normalVector.dy / (normalVector.dx * normalVector.dx + normalVector.dy * normalVector.dy)
        )
        
        orginalVelocity = ballVelocity

        // Apply damping and note length to the new velocity
        ballVelocity = CGVector(dx: ballVelocity.dx * damping, dy: ballVelocity.dy * damping)
//        ballVelocity = CGVector(dx: ballVelocity.dx * damping * 1/CGFloat(noteLength[noteCount]), dy: ballVelocity.dy * damping * 1/CGFloat(noteLength[noteCount]))
//        ballVelocity = CGVector(dx: ballVelocity.dx * damping - CGFloat(noteLength[noteCount]) * 1.5 + 1.5, dy: ballVelocity.dy * damping - CGFloat(noteLength[noteCount]) * 1.5 + 1.5)
        // Move the ball slightly away from the collision point to avoid sticking to the edge
        ballPosition = CGPoint(x: ballPosition.x + ballVelocity.dx * CGFloat(timeStep), y: ballPosition.y + ballVelocity.dy * CGFloat(timeStep))
        timeStep = originalTimeStep * 1/Double(noteLength[noteCount])
        
        firstBounce = false
    }

    private func updateBallPosition() {
        // Update ball position and velocity based on gravity
        var acceleration = CGVector(dx: 0, dy: gravity)
        if firstBounce || gravity != 0 {
            acceleration = CGVector(dx: 0, dy: 1)
        } else {
            acceleration = CGVector(dx: 0, dy: 0)
        }
        ballVelocity = CGVector(dx: ballVelocity.dx + acceleration.dx * CGFloat(timeStep), dy: ballVelocity.dy + acceleration.dy * CGFloat(timeStep))
        ballPosition = CGPoint(x: ballPosition.x + ballVelocity.dx * CGFloat(timeStep), y: ballPosition.y + ballVelocity.dy * CGFloat(timeStep))
        // Check for collision with the edge of the large circle
        var distanceToCenter = ballPosition.distance(to: lrgCircleCenter)
//        print("distanceToCenter: \(distanceToCenter)")
//        print("Bounce - Position: \(ballPosition), Velocity: \(ballVelocity)")
        if distanceToCenter >= lrgCircleRadius - diameter/2 {
            if noteCount < songNotes.count {
                playSound()
            }
            handleCollision()
            // Recalculate the distance to the center after the bounce
            distanceToCenter = ballPosition.distance(to: lrgCircleCenter)
        }

        // Repeat the update until the ball is out of the screen or reaches a specific condition
        if distanceToCenter <= lrgCircleRadius - diameter/2 + 50 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                updateBallPosition()
            }
        } else {
            print("ball out of bounds and stopped")
        }
    }
}

// Extension to calculate distance between two CGPoint
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}

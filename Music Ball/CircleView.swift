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
    @Binding var collision: Bool
    @State private var scale: CGFloat = 1.0
    
    // youtube
    let songNotes1mp3 = ["f4", "d4", "a4", "d4", "f4", "d4", "a4", "d4", "f4", "c4", "a4", "c4", "f4", "c4", "a4", "c4", "e4", "c-4", "a4", "c-4", "e4", "c-4", "a4", "c-4", "e4", "c-4", "a4", "c-4", "e4", "c-4", "a5", "d4", "e4", "f4", "a5", "g4", "a5", "c4", "d4", "e4", "f4", "e4", "g4", "a5", "g4", "f4", "f4", "f4", "f4", "a5", "a5", "g4", "f4", "a5", "a5", "a5", "g4", "a5", "g4", "f4", "f4", "f4", "f4", "a5", "a5", "g4", "f4", "a5", "a5", "a5", "c-5", "c-5", "c-5", "f4", "f4", "f4", "a5", "a5", "g4", "f4", "a-5", "a-5", "a-5", "g4", "c5", "a5", "c-5", "f4", "d4", "f4", "a5", "e4", "c-4", "a5", "c-5", "d5", "d3"]
    // with rests
//    var noteLength = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 6, 2, 8, 3, 3, 2, 8, 6, 2, 4, 4, 4, 4, 4, 4, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4]
    // without rests
//    let noteLength1 = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 6, 2, 8, 3, 3, 2, 8, 6, 2, 4, 4, 4, 4, 4, 5, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4,1,1,1,1,1,1,1,1,4,4]
//    let songNotes1aiff = ["Piano.mf.F4", "Piano.mf.D4", "Piano.mf.A4", "Piano.mf.D4", "Piano.mf.F4", "Piano.mf.D4", "Piano.mf.A4", "Piano.mf.D4", "Piano.mf.F4", "Piano.mf.C4", "Piano.mf.A4", "Piano.mf.C4", "Piano.mf.F4", "Piano.mf.C4", "Piano.mf.A4", "Piano.mf.C4", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A4", "Piano.mf.Db4", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A4", "Piano.mf.Db4", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A4", "Piano.mf.Db4", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A5", "Piano.mf.D4", "Piano.mf.E4", "Piano.mf.F4", "Piano.mf.A5", "Piano.mf.G4", "Piano.mf.A5", "Piano.mf.C4", "Piano.mf.D4", "Piano.mf.E4", "Piano.mf.F4", "Piano.mf.E4", "Piano.mf.G4", "Piano.mf.A5", "Piano.mf.G4", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.A5", "Piano.mf.A5", "Piano.mf.G4", "Piano.mf.F4", "Piano.mf.A5", "Piano.mf.A5", "Piano.mf.A5", "Piano.mf.G4", "Piano.mf.A5", "Piano.mf.G4", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.A5", "Piano.mf.A5", "Piano.mf.G4", "Piano.mf.F4", "Piano.mf.A5", "Piano.mf.A5", "Piano.mf.A5", "Piano.mf.Db5", "Piano.mf.Db5", "Piano.mf.Db5", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.F4", "Piano.mf.A5", "Piano.mf.A5", "Piano.mf.G4", "Piano.mf.F4", "Piano.mf.Bb5", "Piano.mf.Bb5", "Piano.mf.Bb5", "Piano.mf.G4", "Piano.mf.C5", "Piano.mf.A5", "Piano.mf.Db5", "Piano.mf.F4", "Piano.mf.D4", "Piano.mf.F4", "Piano.mf.A5", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A5", "Piano.mf.Db5", "Piano.mf.D5", "Piano.mf.D3"]
    // musescore
    let songNotes1=["Piano.mf.F4", "Piano.mf.D4", "Piano.mf.A3", "Piano.mf.D4", "Piano.mf.F4", "Piano.mf.D4", "Piano.mf.A3", "Piano.mf.D4", "Piano.mf.F4", "Piano.mf.C4", "Piano.mf.A3", "Piano.mf.C4", "Piano.mf.F4", "Piano.mf.C4", "Piano.mf.A3", "Piano.mf.C4", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A3", "Piano.mf.Db4", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A3", "Piano.mf.Db4", "Piano.mf.E4", "Piano.mf.Db4", "Piano.mf.A3", "Piano.mf.Db4", "Piano.mf.E4", "Piano.mf.A4", "Piano.mf.D4", "Piano.mf.E4", "Piano.mf.F4", "Piano.mf.A4", "Piano.mf.G4", "Piano.mf.A4", "Piano.mf.C4"]
    let noteLengthRight = [1.0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 6, 2, 8, 3, 3, 2, 8, 4, 2, 2, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 8]
    let noteLengthMiddle = [1.0, 8, 8, 8, 4, 4, 6, 2, 8, 3, 3, 2, 8, 4, 2, 2, 4, 4, 4, 4, 4, 4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 8, 8]
    let noteLengthMiddle2 = [1, 40.85, 8, 3, 29, 4, 108, 4, 4, 8]
//    let songNotes2aiff = ["Piano.mf.D2", "Piano.mf.F2", "Piano.mf.A2", "Piano.mf.A2", "Piano.mf.A2", "Piano.mf.D1", "Piano.mf.A1", "Piano.mf.D2", "Piano.mf.A1", "Piano.mf.F2", "Piano.mf.D2", "Piano.mf.A2", "Piano.mf.D2", "Piano.mf.D1", "Piano.mf.A1", "Piano.mf.D2", "Piano.mf.A1", "Piano.mf.F2", "Piano.mf.D2", "Piano.mf.A2", "Piano.mf.D2", "Piano.mf.F1", "Piano.mf.C2", "Piano.mf.F2", "Piano.mf.C2", "Piano.mf.A2", "Piano.mf.F2", "Piano.mf.C2", "Piano.mf.F2", "Piano.mf.F1", "Piano.mf.C2", "Piano.mf.F2", "Piano.mf.C2", "Piano.mf.A2", "Piano.mf.F2", "Piano.mf.C2", "Piano.mf.F2"]
    let songNotes2aiff = ["Piano.pp.D2", "Piano.pp.F2", "Piano.pp.A2", "Piano.pp.A2", "Piano.pp.A2", "Piano.pp.D1", "Piano.pp.A1", "Piano.pp.D2", "Piano.pp.A1", "Piano.pp.F2", "Piano.pp.D2", "Piano.pp.A2", "Piano.pp.D2", "Piano.pp.D1", "Piano.pp.A1", "Piano.pp.D2", "Piano.pp.A1", "Piano.pp.F2", "Piano.pp.D2", "Piano.pp.A2", "Piano.pp.D2", "Piano.pp.F1", "Piano.pp.C2", "Piano.pp.F2", "Piano.pp.C2", "Piano.pp.A2", "Piano.pp.F2", "Piano.pp.C2", "Piano.pp.F2", "Piano.pp.F1", "Piano.pp.C2", "Piano.pp.F2", "Piano.pp.C2", "Piano.pp.A2", "Piano.pp.F2", "Piano.pp.C2", "Piano.pp.F2"]
    let noteLengthLeft = [1.0, 8, 8, 8, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 8, 4, 4]
//    let noteLength2 = [8, 8, 8, 4, 4]
    
    // musescore midi
    let songNotesRightmidi = [65, 62, 57, 62, 65, 62, 57, 62, 65, 60, 57, 60, 65, 60, 57, 60, 64, 61, 57, 61, 64, 61, 57, 61, 64, 61, 57, 61, 64, 69, 62, 64, 65, 69, 67, 69, 60, 62, 0, 64, 65, 64, 67, 69, 67, 65, 0, 65, 65, 65, 69, 69, 67, 65, 0, 69, 69, 69, 67, 69, 67, 65, 0, 65, 65, 65, 69, 69, 67, 65, 0, 69, 69, 69, 0, 73, 73, 73, 0, 65, 65, 65, 69, 69, 67, 65, 0, 74, 74, 74, 67, 72, 69, 73, 65, 62, 65, 69, 64, 61, 69, 73, 86]
    let songNotesLeftmidi = [38, 41, 45, 45, 45, 26, 33, 38, 33, 41, 38, 45, 38, 26, 33, 38, 33, 41, 38, 45, 38, 29, 36, 41, 36, 45, 41, 36, 41, 29, 36, 41, 36, 45, 41, 36, 41, 34, 41, 46, 41, 50, 46, 41, 46, 34, 41, 46, 41, 50, 46, 41, 46, 36, 43, 48, 43, 52, 48, 43, 36, 36, 40, 45, 40, 49, 45, 40, 33, 26, 33, 38, 33, 26, 33, 38, 33, 26, 33, 38, 33, 26, 33, 28, 33, 29, 36, 41, 36, 29, 36, 41, 36, 29, 36, 41, 36, 29, 36, 41, 36, 34, 41, 46, 41, 34, 41, 46, 41, 34, 41, 46, 41, 34, 41, 46, 41, 36, 43, 48, 43, 36, 43, 34, 43, 33, 40, 45, 40, 33, 40, 45, 40, 26, 33, 38, 33, 26, 33, 28, 33, 29, 36, 41, 36, 29, 36, 41, 36, 34, 41, 46, 41, 34, 41, 46, 41, 36, 43, 48, 43, 36, 43, 48, 43, 33, 40, 45, 40, 33, 40, 45, 50, 0, 26]
    let songNotesMiddlemidi = [26, 29, 33, 33, 33, 50, 52, 53, 57, 55, 57, 48, 50, 0, 52, 53, 0, 55, 57, 55, 53, 0, 53, 53, 53, 57, 57, 55, 53, 0, 57, 57, 57, 55, 57, 55, 53, 0, 53, 53, 53, 57, 57, 55, 53, 0, 57, 57, 57, 0, 61, 61, 61, 0, 53, 53, 53, 57, 57, 55, 53, 0, 58, 58, 58, 55, 60, 57, 61, 38, 74]
    let songNotesMiddle2midi = [0, 57, 60, 0, 60, 0, 61, 64, 45]
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.accentColor, lineWidth: 6) // Adjust the line width as needed
//                .frame(width: circleDiameter, height: circleDiameter)
                .frame(width: circleDiameter * scale, height: circleDiameter * scale)
                .onChange(of: collision) { newValue in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        scale = 1.05 // Set the scale factor for expansion
                    }
                    withAnimation(.easeInOut(duration: 0.1).delay(0.1)) { // play with delay to see what feels right
                        scale = 1
                    }
                }
//            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 100, y: 293), color: Color.red, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag, collision: $collision, isSound: true, fileType: "mp3", songNotes: songNotes1mp3, noteLength: noteLength1)
//            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 100, y: 293), color: Color.red, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag, collision: $collision, isSound: true, soundLvl: "mf", fileType: "aiff", songNotes: songNotes1aiff, noteLength: noteLength1)
//            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 100, y: 293), color: Color.blue, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag, collision: $collision, isSound: true, soundLvl: "pp", fileType: "aiff", songNotes: songNotes2aiff, noteLength: noteLength2)
            
            // midi
            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 254.25, y: 275), color: Color.blue, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag, collision: $collision, isSound: true, soundLvl: "pp", fileType: "aiff", songNotes: songNotesLeftmidi, noteLength: noteLengthLeft)
            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 105.75, y: 275), color: Color.green, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag, collision: $collision, isSound: true, soundLvl: "mf", fileType: "aiff", songNotes: songNotesRightmidi, noteLength: noteLengthRight)
            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 105.75, y: 275), color: Color.red, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag, collision: $collision, isSound: true, soundLvl: "mf", fileType: "aiff", songNotes: songNotesMiddlemidi, noteLength: noteLengthMiddle)
//            BallView(gravity: 0, damping: 1, diameter: 25, position: CGPoint(x: 105.75, y: 275), color: Color.yellow, lrgCircleRadius: circleRadius, lrgCircleCenter: circleCenter, resetFlag: $resetFlag, collision: $collision, isSound: true, soundLvl: "pp", fileType: "aiff", songNotes: songNotesMiddle2midi, noteLength: noteLengthMiddle2)
        }
    }
}

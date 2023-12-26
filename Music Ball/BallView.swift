//
//  BallView.swift
//  Music Ball
//
//  Created by Dhruv Chowdhary on 12/18/23.
//

import SwiftUI
import AVFoundation
import AudioToolbox


struct BallView: View {
    @State private var ballPosition: CGPoint
    var initialBallPosition: CGPoint
    @State private var ballVelocity = CGVector(dx: 0, dy: 0)
    @State private var ballPath = Path()
    var gravity: CGFloat
    var damping: CGFloat
    var diameter: CGFloat
    var color: Color
    var lrgCircleRadius: CGFloat
    var lrgCircleCenter: CGPoint
    @State private var timeStep = 0.7
    @State private var originalTimeStep = 0.7
    @State private var firstBounce = true
    var songNotes: Array<Int>
    var noteLength: Array<Double>
    @State private var noteCount = 0
    @State private var orginalVelocity = CGVector(dx: 0, dy: 1) // Velocity without the noteLength
    var isSound: Bool
    var fileType: String
    var soundLvl: String
    
    @Binding var resetFlag: Bool
    @Binding var collision: Bool
    
    @State private var audio: AVPlayer?

    init(gravity: CGFloat, damping: CGFloat, diameter: CGFloat, position: CGPoint, color: Color, lrgCircleRadius: CGFloat, lrgCircleCenter: CGPoint, resetFlag: Binding<Bool>, collision: Binding<Bool>, isSound: Bool, soundLvl: String, fileType: String, songNotes: Array<Int>, noteLength: Array<Double>) {
        self.gravity = gravity
        self.damping = damping
        self.diameter = diameter
        _ballPosition = State(initialValue: position)
        _ballPath = State(initialValue: Path { path in
            path.move(to: position)
        })
        self.color = color
        self.lrgCircleRadius = lrgCircleRadius
        self.lrgCircleCenter = lrgCircleCenter
        _resetFlag = resetFlag
        _collision = collision
        self.initialBallPosition = position
        self.isSound = isSound
        self.soundLvl = soundLvl
        self.fileType = fileType
        self.songNotes = songNotes
        self.noteLength = noteLength
    }
    
    @State private var processingGraph: AUGraph?
    @State private var midisynthNode = AUNode()
    @State private var ioNode = AUNode()
    @State private var midisynthUnit: AudioUnit?

    func initAudio() {
        checkError(osstatus: NewAUGraph(&processingGraph))
        createIONode()
        createSynthNode()
        checkError(osstatus: AUGraphOpen(processingGraph!))
        checkError(osstatus: AUGraphNodeInfo(processingGraph!, midisynthNode, nil, &midisynthUnit))

        // Load Sound Font
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let soundFontURL = Bundle.main.url(forResource: "IK_Berlin_Grand_Piano", withExtension: "sf2") {
                var bankURL = Unmanaged.passUnretained(soundFontURL as CFURL).toOpaque()
                let propertySize = UInt32(MemoryLayout<URL>.size)
                checkError(osstatus: AudioUnitSetProperty(midisynthUnit!,
                                                          kMusicDeviceProperty_SoundBankURL,
                                                          kAudioUnitScope_Global,
                                                          0,
                                                          &bankURL,
                                                          propertySize))
            } else {
                print("Sound font file not found.")
            }
        }

        let synthOutputElement: AudioUnitElement = 0
        let ioUnitInputElement: AudioUnitElement = 0

        checkError(osstatus:
            AUGraphConnectNodeInput(processingGraph!, midisynthNode, synthOutputElement, ioNode, ioUnitInputElement))

        checkError(osstatus: AUGraphInitialize(processingGraph!))
        checkError(osstatus: AUGraphStart(processingGraph!))
    }


    
    // Function to create the I/O node
    private func createIONode() {
        var cd = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_Output),
            componentSubType: OSType(kAudioUnitSubType_RemoteIO),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0
        )
        
        checkError(osstatus: AUGraphAddNode(processingGraph!, &cd, &ioNode))
    }

    // Function to create the synth node
    private func createSynthNode() {
        var cd = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_MusicDevice),
            componentSubType: OSType(kAudioUnitSubType_MIDISynth),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0
        )
        
        checkError(osstatus: AUGraphAddNode(processingGraph!, &cd, &midisynthNode))
    }

    
    func checkError(osstatus: OSStatus) {
        if osstatus != noErr {
            fatalError("Error: \(osstatus)")
        }
    }
    
    func noteOn(note: UInt8) {
        if !firstBounce {
            noteOff(note: UInt8(songNotes[noteCount - 1]))
        }
        let noteCommand = UInt32(0x90)
        let pitch = UInt32(note)
        var velocity = UInt32(127) // Adjust the velocity as needed
        if soundLvl == "pp" {
            velocity = 85
        }
        if note != 0 {
            checkError(osstatus: MusicDeviceMIDIEvent(midisynthUnit!, noteCommand, pitch, velocity, 0))
        }
        noteCount += 1
    }

    func noteOff(note: UInt8) {
        let noteCommand = UInt32(0x80)
        let pitch = UInt32(note)
        let velocity = UInt32(0) // Note off with zero velocity
        checkError(osstatus: MusicDeviceMIDIEvent(midisynthUnit!, noteCommand, pitch, velocity, 0))
    }

    var body: some View {
        ballPath.stroke(color, lineWidth: 1)
        Circle()
            .fill(color)
            .frame(width: diameter, height: diameter)
            .position(ballPosition)
            .onAppear {
                initAudio()
//                let filePath = URL(fileURLWithPath: Bundle.main.path(forResource: "mp3Notes", ofType: nil)!).appendingPathComponent(songNotes[0]).appendingPathExtension("mp3")
//                audio = AVPlayer.init(url: filePath)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    initiateAnimation()
                }
            }
            .onChange(of: resetFlag) { newValue in      // Reset the ball position when resetFlag changes
                noteOff(note: UInt8(songNotes[noteCount]))
                ballPosition = initialBallPosition
                ballPath = Path { path in
                    path.move(to: initialBallPosition)
                }
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
        guard let folderPath = Bundle.main.path(forResource: fileType + "Notes", ofType: nil) else {
            return
        }
//        let filePath = URL(fileURLWithPath: folderPath).appendingPathComponent(songNotes[noteCount]).appendingPathExtension(fileType)
        
//        audio = AVPlayer.init(url: filePath)
        audio?.play()
        let timeScale = audio?.currentItem?.asset.duration.timescale
        if fileType == "aiff" {
            if soundLvl == "mf" {
                let seektime = CMTimeMakeWithSeconds(0.695, preferredTimescale: timeScale!);
                audio?.seek(to: seektime)
            } else if soundLvl == "pp" {
                let seektime = CMTimeMakeWithSeconds(0.311, preferredTimescale: timeScale!);
                audio?.seek(to: seektime)
            }
        } else if fileType == "mp3" {
            let seektime = CMTimeMakeWithSeconds(0.025, preferredTimescale: timeScale!);
            audio?.seek(to: seektime)
        }
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

        // Apply damping to the new velocity
        ballVelocity = CGVector(dx: ballVelocity.dx * damping, dy: ballVelocity.dy * damping)
        
        // Move the ball slightly away from the collision point to avoid sticking to the edge
        ballPosition = CGPoint(x: ballPosition.x + ballVelocity.dx * CGFloat(timeStep), y: ballPosition.y + ballVelocity.dy * CGFloat(timeStep))

        timeStep = originalTimeStep * 1/Double(noteLength[noteCount])
        
        firstBounce = false
    }

    private func updateBallPosition() {
        // Update ball position and velocity based on gravity
        var acceleration = CGVector(dx: 0, dy: gravity)
        if firstBounce {
            acceleration = CGVector(dx: 0, dy: 1)
        } else if gravity != 0 {
            acceleration = CGVector(dx: 0, dy: gravity)
        } else {
            acceleration = CGVector(dx: 0, dy: 0)
        }
        ballVelocity = CGVector(dx: ballVelocity.dx + acceleration.dx * CGFloat(timeStep), dy: ballVelocity.dy + acceleration.dy * CGFloat(timeStep))
        ballPosition = CGPoint(x: ballPosition.x + ballVelocity.dx * CGFloat(timeStep), y: ballPosition.y + ballVelocity.dy * CGFloat(timeStep))
        // Check for collision with the edge of the large circle
        var distanceToCenter = ballPosition.distance(to: lrgCircleCenter)
        if distanceToCenter >= lrgCircleRadius - diameter/2 {
            if isSound && noteCount < songNotes.count {
                noteOn(note: UInt8(songNotes[noteCount]))
//                playSound()
            }
            handleCollision()
            withAnimation(.easeInOut(duration: 0.1)) {
                // Scale up the circle when the ball hits the edge
                collision.toggle()
                
            }
            // Recalculate the distance to the center after the bounce
            distanceToCenter = ballPosition.distance(to: lrgCircleCenter)
        }
        ballPath.addLine(to: ballPosition)

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

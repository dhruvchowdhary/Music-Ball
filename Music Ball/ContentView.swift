//
//  ContentView.swift
//  Music Ball
//
//  Created by Dhruv Chowdhary on 12/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var resetFlag = false // State variable to trigger a reset

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                CircleView(resetFlag: $resetFlag) // Pass the reset flag to CircleView
                Button("Restart") {
                    resetFlag.toggle() // Toggle the reset flag to trigger a reset
                }
                .foregroundColor(.black)
            }
            .padding()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

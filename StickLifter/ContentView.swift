//
//  ContentView.swift
//  StickLifter
//
//  Created by Jonathan Stroble on 11/9/25.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    var body: some View {
        SceneView(
            scene: StickFigureScene(),
            pointOfView: nil,
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}



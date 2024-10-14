//
//  ContentView.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var scene = GameScene(size: CGSize(width: 375, height: 667))
    var body: some View {
        ZStack {
            SpriteView(scene: scene, options: [.ignoresSiblingOrder], debugOptions: [.showsDrawCount, .showsFPS, .showsNodeCount])
                .ignoresSafeArea()
                .onTapGesture {
                    scene.cycle()
                }
                .gesture(DragGesture().onEnded { value in
                    if value.translation.width > 0 {
                        scene.right()
                    } else if value.translation.width < 0 {
                        scene.left()
                    }
                })
            VStack {
                Spacer()
                Text("Score: \(scene.score)")
                Text("Level: \(scene.level)")                
            }
            .foregroundStyle(.white)
            .padding()
            .font(.largeTitle)
            
            if scene.state == .loss {
                VStack {
                    Text("You lost!")
                        .foregroundStyle(.white)
                    Button("Try Again") {
                        scene.reset()
                    }
                }
                .font(.largeTitle)
                .padding()
                .padding()
                .background(Color.secondary)
                .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    ContentView()
}

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
            SpriteView(scene: scene, options: [.ignoresSiblingOrder])
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
            HStack {
                VStack {
                    Spacer()
                    Text("Score: \(scene.score)")
                    Text("Level: \(scene.level)")
                }
                Text(" ")
                VStack {
                    Spacer()
                    Text("Next:")
                    Image(scene.board.nextGems[2].rawValue)
                    Image(scene.board.nextGems[1].rawValue)
                    Image(scene.board.nextGems[0].rawValue)
                }
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

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
            VStack {
                Spacer()
                HStack {
                    Button {
                        scene.left()
                    } label: {
                        Image(systemName: "arrowshape.left.fill")
                        Text("Left  ")
                    }
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(Color.secondary)
                    .clipShape(.capsule)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    Button {
                        scene.right()
                    } label: {
                        Text("Right")
                        Image(systemName: "arrowshape.right.fill")
                    }
                    
                    .foregroundColor(.accentColor)
                    .padding()
                    .background(Color.secondary)
                    .clipShape(.capsule)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
                
                Button {
                    scene.cycle()
                } label: {
                    Image(systemName: "arrow.circlepath")
                    Text("Cycle")
                }
                .foregroundColor(.accentColor)
                .padding()
                .background(Color.secondary)
                .clipShape(.capsule)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                Text("").padding()
            }
            .padding()                
            .font(.largeTitle)
            if scene.state == .loss {
                VStack {
                    Text("State: \(scene.board.state)")
                    Button("Try Again") {
                        scene.reset()
                    }
                }
                .font(.largeTitle)
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

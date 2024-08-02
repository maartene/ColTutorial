//
//  ContentView.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    let scene = GameScene(size: CGSize(width: 375, height: 667))
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
                    Spacer()
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
                .padding()
                .font(.largeTitle)
                Text("").padding()
            }
            
        }
    }
}

#Preview {
    ContentView()
}

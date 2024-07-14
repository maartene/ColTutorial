//
//  ContentView.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var body: some View {
        SpriteView(scene: GameScene(size: CGSize(width: 375, height: 667)), options: [.ignoresSiblingOrder], debugOptions: [.showsDrawCount, .showsFPS, .showsNodeCount])
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}

//
//  GameScene.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import Foundation
import SpriteKit

final class GameScene: SKScene {
    let spriteSize = 32.0
    let colCount = 6
    let rowCount = 13
    let updateInterval = 0.5
    
    var board = Board()
    var offset: CGPoint = .zero
    
    let rootNode = SKNode()
    
    var lastUpdateTime: TimeInterval = 0
    var updateDelayRemaining: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFit
        backgroundColor = .black
        
        addChild(rootNode)
        
        let field = SKShapeNode(rect: CGRect(x: 0, y: 0, width: spriteSize * Double(colCount), height: spriteSize *  Double(rowCount)))
        field.strokeColor = .white
        field.fillColor = .darkGray
        offset = CGPoint(x: size.width / 2.0 - field.frame.size.width / 2.0, y: size.height - spriteSize - field.frame.size.height)
        field.position = offset
        field.zPosition = -1
        addChild(field)
        
        board.gems[Vector(x: 3, y: 13)] = .green
        board.gems[Vector(x: 0, y: 0)] = .red
        board.gems[Vector(x: 0, y: 5)] = .blue
        
        drawBoard()
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        updateDelayRemaining -= deltaTime
        if updateDelayRemaining <= 0 {
            board = board.update()
            drawBoard()
            updateDelayRemaining = updateInterval
        }
    }
    
    func drawBoard() {
        for child in rootNode.children {
            child.removeFromParent()
        }
        
        for gem in board.gems {
            let position = CGPoint(x: Double(gem.key.x) * spriteSize, y: Double(gem.key.y) * spriteSize) + offset + CGPoint(x: spriteSize / 2.0, y: spriteSize / 2.0)
            
            let gemShape = SKShapeNode(circleOfRadius: spriteSize / 2.0)
            gemShape.fillColor = gem.value.color
            gemShape.position = position
            rootNode.addChild(gemShape)
        }
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension Gem {
    var color: SKColor {
        switch self {
        case .red:
                .red
        case .green:
                .green
        case .blue:
                .blue
        case .yellow:
                .yellow
        case .purple:
                .purple
        }
    }
}

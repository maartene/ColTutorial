//
//  GameScene.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import Foundation
import SpriteKit

final class GameScene: SKScene, ObservableObject {
    let spriteSize = 32.0
    let updateInterval = 0.5
    
    var board = Board()
    var offset: CGPoint = .zero
    
    let rootNode = SKNode()
    
    var lastUpdateTime: TimeInterval = 0
    var updateDelayRemaining: TimeInterval = 0
    
    @Published var state = Board.BoardState.inProgress
    
    override func didMove(to view: SKView) {
        scaleMode = .aspectFit
        backgroundColor = .black
        
        addChild(rootNode)
        
        let field = SKShapeNode(rect: CGRect(x: 0, y: 0, width: spriteSize * Double(board.colCount), height: spriteSize *  Double(board.rowCount)))
        field.strokeColor = .white
        field.fillColor = .darkGray
        offset = CGPoint(x: size.width / 2.0 - field.frame.size.width / 2.0, y: size.height - spriteSize - field.frame.size.height)
        field.position = offset
        field.zPosition = -1
        addChild(field)
        
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
            state = board.state
        }
    }
    
    func left() {
        board = board.left()
        drawBoard()
    }
    
    func right() {
        board = board.right()
        drawBoard()
    }
    
    func cycle() {
        board = board.cycle()
        drawBoard()
    }
    
    func drawBoard() {
        for child in rootNode.children {
            child.removeFromParent()
        }
        
        for gem in board.gems {
            let position = CGPoint(x: Double(gem.key.x) * spriteSize, y: Double(gem.key.y) * spriteSize) + offset + CGPoint(x: spriteSize / 2.0, y: spriteSize / 2.0)
            
            let gemShape = SKSpriteNode(imageNamed: gem.value.rawValue)
            gemShape.position = position
            rootNode.addChild(gemShape)
        }
        
        for removedGem in board.matches {
            if let gib = SKNode(fileNamed: "\(removedGem.gem).sks") {
                let position = CGPoint(x: Double(removedGem.pos.x) * spriteSize, y: Double(removedGem.pos.y) * spriteSize) + offset + CGPoint(x: spriteSize / 2.0, y: spriteSize / 2.0)
                gib.position = position
                gib.run(.sequence([.wait(forDuration: 0.5), .removeFromParent()]))
                rootNode.addChild(gib)
            }
        }
    }
    
    func reset() {
        board = Board()
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

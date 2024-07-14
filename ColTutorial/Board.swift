//
//  Board.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import Foundation

enum Gem: String {
    case red
    case green
    case blue
    case yellow
    case purple
}

struct Board {
    var gems = [Vector: Gem]()
    
    subscript(coord: Vector) -> Gem? {
        gems[coord]
    }
    
    func update() -> Board {
        var updatedBoard = self
        
        for gem in gems {
            // is there space below the gem?
            if gems[gem.key + .down] == nil && gem.key.y > 0 {
                updatedBoard.gems.removeValue(forKey: gem.key)
                updatedBoard.gems[gem.key + .down] = gem.value
            }
        }
        
        return updatedBoard
    }
}

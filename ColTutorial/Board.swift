//
//  Board.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import Foundation

enum Gem: String, CaseIterable {
    case red
    case green
    case blue
    case yellow
    case purple
}

struct Board {
    let colCount = 6
    let rowCount = 13

    var gems = [Vector: Gem]()
    
    subscript(coord: Vector) -> Gem? {
        gems[coord]
    }
    
    
    func update() -> Board {
        var updatedBoard = self
        
        let aGemHasFallen = updatedBoard.moveGemsDownWherePossible()
        
        // spawn a new column
        if aGemHasFallen == false {
            updatedBoard.spawnNewGems()
        }
        
        return updatedBoard
    }
    
    private mutating func moveGemsDownWherePossible() -> Bool {
        var aGemHasFallen = false
        
        for y in 0 ... 16 {
            for x in 0 ..< 6 {
                let coord = Vector(x: x, y: y)
                if let gem = gems[coord] {
                    // is there space below the gem?
                    if gems[coord + .down] == nil && coord.y > 0 {
                        moveGemDown(coord, gem: gem)
                        aGemHasFallen = true
                    }
                }
            }
        }
        
        return aGemHasFallen
    }
    
    private mutating func moveGemDown(_ coord: Vector, gem: Gem) {
        gems.removeValue(forKey: coord)
        gems[coord + .down] = gem
    }
    
    private mutating func spawnNewGems() {
        gems[Vector(x: 3, y: 13)] = Gem.allCases.randomElement()!
        gems[Vector(x: 3, y: 14)] = Gem.allCases.randomElement()!
        gems[Vector(x: 3, y: 15)] = Gem.allCases.randomElement()!
    }
    
}

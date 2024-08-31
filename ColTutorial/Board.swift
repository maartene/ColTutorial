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
    
    var fallingStackBottom = Vector(x: 13, y: 3)
    
    subscript(coord: Vector) -> Gem? {
        gems[coord]
    }

    func update() -> Board {
        var updatedBoard = self
        
        let aGemHasFallen = updatedBoard.moveGemsDownWherePossible()
        
        // find matches
        let matches = updatedBoard.findMatches()
        for match in matches {
            updatedBoard.gems.removeValue(forKey: match)
        }
        
        // spawn a new column
        if aGemHasFallen == false && matches.count == 0 {
            updatedBoard.spawnNewGems()
        } else {
            updatedBoard.fallingStackBottom = fallingStackBottom + .down
        }
        
        return updatedBoard
    }
    
    private func move(direction: Vector) -> Board {
        var updatedBoard = self
        
        guard fallingStackBottom.x + direction.x >= 0 && fallingStackBottom.x + direction.x < colCount else {
            return self
        }
        
        guard self[fallingStackBottom + direction] == nil else {
            return self
        }
        
        updatedBoard.fallingStackBottom = fallingStackBottom + direction
        
        updatedBoard.gems[fallingStackBottom + direction] = self[fallingStackBottom]
        updatedBoard.gems[fallingStackBottom + direction + .up] = self[fallingStackBottom + .up]
        updatedBoard.gems[fallingStackBottom + direction + .up + .up] = self[fallingStackBottom + .up + .up]
        
        updatedBoard.gems[fallingStackBottom] = nil
        updatedBoard.gems[fallingStackBottom + .up] = nil
        updatedBoard.gems[fallingStackBottom + .up + .up] = nil
        
        return updatedBoard
    }
    
    func right() -> Board {
        move(direction: .right)
    }
    
    func left() -> Board {
        move(direction: .left)
    }
    
    func cycle() -> Board {
        var updatedBoard = self
        
        updatedBoard.gems[fallingStackBottom] = self[fallingStackBottom + .up]
        updatedBoard.gems[fallingStackBottom + .up] = self[fallingStackBottom + .up + .up]
        updatedBoard.gems[fallingStackBottom + .up + .up] = self[fallingStackBottom]
        
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
        
        fallingStackBottom = Vector(x: 3, y: 13)
    }
    
    // MARK: Find matches
    func findMatches() -> Set<Vector> {
        var result = Set<Vector>()
        
        let directions = [
            Vector.right,
            Vector.up
        ]
        
        for y in 0 ..< rowCount {
            for x in 0 ..< colCount {
                let coord = Vector(x: x, y: y)
                for direction in directions {
                    result.formUnion(findMatches(startingAt: coord, direction: direction))
                }
            }
        }
        
        return result
    }
    
    func findMatches(startingAt coord: Vector, direction: Vector) -> Set<Vector> {
        var result = Set<Vector>()
        if let gem = gems[coord] {
            var d = 1
            var matchSequence: Set<Vector> = [coord]
            while gem == gems[coord + direction * d] {
                matchSequence.insert(coord + direction * d)
                d += 1
            }
            if matchSequence.count >= 3 {
                result.formUnion(matchSequence)
            }
        }
        return result
    }
}

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

struct VectorGem {
    let pos: Vector
    let gem: Gem
}

extension VectorGem: Hashable { }

struct Board {
    enum BoardState {
        case loss
        case inProgress
    }
    
    let colCount = 6
    let rowCount = 13

    var gems = [Vector: Gem]()
    
    var fallingStackBottom = Vector(x: 3, y: 13)
    var matches: Set<VectorGem> = []
    
    var state = BoardState.inProgress
    var score = 0
    var comboMultiplier = 1
    
    var level = 1
    var spawnCount = 0
    var updateDelay: TimeInterval {
        let result = 0.55 - Double(level) * 0.05
        return max(0, result)
    }
    
    var nextGems: [Gem] = [Gem.blue, Gem.red, Gem.blue]
    
    subscript(coord: Vector) -> Gem? {
        gems[coord]
    }
    
    func update() -> Board {
        var updatedBoard = self
        
        let aGemHasFallen = updatedBoard.moveGemsDownWherePossible()
        
        // find matches
        updatedBoard.matches = updatedBoard.findMatches()
        for match in updatedBoard.matches {
            updatedBoard.gems.removeValue(forKey: match.pos)
        }
        updatedBoard.updateScore()
        
        updatedBoard.updateLevel()
        
        
        // determine loss/continue/spawn
        let matchesFound = updatedBoard.matches.count > 0
        let boardIsStable = (aGemHasFallen == false) && (matchesFound == false)
        let spawnPositionIsOccupied = updatedBoard.gems[Vector(x: 3, y: 13)] != nil
        
        switch (boardIsStable, spawnPositionIsOccupied) {
        case (true, false):
            // board is stable, but not a loss -> spawn a new set of gems and reset combo multiplier
            updatedBoard.spawnNewGems()
            updatedBoard.comboMultiplier = 1
        case (true, true):
            // board is stable, and no space for new gems -> loss
            updatedBoard.state = .loss
        case (false, _):
            // board is not yet stable, just move stuff down
            updatedBoard.fallingStackBottom = fallingStackBottom + .down
        }
        
        return updatedBoard
    }
    
    private mutating func updateScore() {
        score += matches.count * comboMultiplier * level
        if matches.count >= 3 {
            comboMultiplier += 5
        }
    }
    
    mutating private func updateLevel() {
        // update level
        if spawnCount >= 10 {
            level += 1
            spawnCount = 0
        }
    }
    
    private func move(direction: Vector) -> Board {
        guard state == .inProgress else {
            return self
        }
        
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
        guard state == .inProgress else {
            return self
        }
        
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
        gems[Vector(x: 3, y: 13)] = nextGems[0]
        gems[Vector(x: 3, y: 14)] = nextGems[1]
        gems[Vector(x: 3, y: 15)] = nextGems[2]
        
        nextGems = randomGems()
        
        fallingStackBottom = Vector(x: 3, y: 13)
        spawnCount += 1
    }
    
    private func randomGems() -> [Gem] {
        var nextGems = [
            Gem.allCases.randomElement()!,
            Gem.allCases.randomElement()!,
            Gem.allCases.randomElement()!
        ]
        
        if nextGems[0] == nextGems[1] && nextGems[1] == nextGems[2] {
            while nextGems[1] == nextGems[0] {
                nextGems[1] = Gem.allCases.randomElement()!
            }
        }
        
        return nextGems
    }
    
    // MARK: Find matches
    func findMatches() -> Set<VectorGem> {
        var result = Set<VectorGem>()
        
        let directions = [
            Vector.up,
            Vector.right,
            Vector.up + Vector.right,
            Vector.down + Vector.right,
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
    
    func findMatches(startingAt coord: Vector, direction: Vector) -> Set<VectorGem> {
        var result = Set<VectorGem>()
        if let gem = gems[coord] {
            var delta = direction
            var matchSequence: Set<VectorGem> = [VectorGem(pos: coord, gem: gem)]
            while gem == gems[coord + delta] {
                matchSequence.insert(VectorGem(pos: coord + delta, gem: gem))
                delta = delta + direction
            }
            if matchSequence.count >= 3 {
                result.formUnion(matchSequence)
            }
        }
        return result
    }
}

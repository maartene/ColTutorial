//
//  DetectMatchesTests.swift
//  ColTutorialTests
//
//  Created by Maarten Engels on 25/08/2024.
//

import Foundation
import XCTest
@testable import ColTutorial

final class DetectMatchesTests: XCTestCase {
    
    // MARK: Horizontal
    func test_detectHorizontalMatch3_onFloor() {
        var board = Board()
        board.gems[Vector(x: 1, y: 0)] = .green
        board.gems[Vector(x: 2, y: 0)] = .green
        board.gems[Vector(x: 3, y: 0)] = .green
        
        XCTAssertEqual(board.findMatches().count, 3)
    }
    
    func test_detectHorizontalMatch3_returnsCoordsOfMatchingGems() {
        var board = Board()
        board.gems[Vector(x: 1, y: 0)] = .green
        board.gems[Vector(x: 2, y: 0)] = .green
        board.gems[Vector(x: 3, y: 0)] = .green
        
        let result = board.findMatches()
        XCTAssertTrue(result.contains(Vector(x: 1, y: 0)))
        XCTAssertTrue(result.contains(Vector(x: 2, y: 0)))
        XCTAssertTrue(result.contains(Vector(x: 3, y: 0)))
    }
    
    func test_detectHorizontalMatch3_returnsNoCoords_ifNothingMatched() {
        var board = Board()
        board.gems[Vector(x: 1, y: 0)] = .green
        board.gems[Vector(x: 2, y: 0)] = .green
        board.gems[Vector(x: 3, y: 0)] = .red
        
        let result = board.findMatches()
        XCTAssertEqual(result.count, 0)
    }
    
    func test_detectHorizontalMatch3_returnsCoordsOfMatchingGems_alsoForFourInARow() {
        var board = Board()
        board.gems[Vector(x: 1, y: 0)] = .green
        board.gems[Vector(x: 2, y: 0)] = .green
        board.gems[Vector(x: 3, y: 0)] = .green
        board.gems[Vector(x: 4, y: 0)] = .green
        
        let result = board.findMatches()
        XCTAssertTrue(result.contains(Vector(x: 1, y: 0)))
        XCTAssertTrue(result.contains(Vector(x: 2, y: 0)))
        XCTAssertTrue(result.contains(Vector(x: 3, y: 0)))
        XCTAssertTrue(result.contains(Vector(x: 4, y: 0)))
    }
    
    // MARK: Vertical
    func test_detectVerticalMatch3_onFloor() {
        var board = Board()
        board.gems[Vector(x: 0, y: 0)] = .red
        board.gems[Vector(x: 0, y: 1)] = .green
        board.gems[Vector(x: 0, y: 2)] = .green
        board.gems[Vector(x: 0, y: 3)] = .green
        
        XCTAssertEqual(board.findMatches().count, 3)
    }
    
    func test_detectVerticalMatch3_returnsCoordsOfMatchingGems() {
        var board = Board()
        board.gems[Vector(x: 0, y: 0)] = .blue
        board.gems[Vector(x: 0, y: 1)] = .green
        board.gems[Vector(x: 0, y: 2)] = .green
        board.gems[Vector(x: 0, y: 3)] = .green
        
        let result = board.findMatches()
        XCTAssertTrue(result.contains(Vector(x: 0, y: 1)))
        XCTAssertTrue(result.contains(Vector(x: 0, y: 2)))
        XCTAssertTrue(result.contains(Vector(x: 0, y: 3)))
    }
    
    func test_detectVerticalMatch3_returnsNoCoords_ifNothingMatched() {
        var board = Board()
        board.gems[Vector(x: 0, y: 0)] = .yellow
        board.gems[Vector(x: 0, y: 1)] = .green
        board.gems[Vector(x: 0, y: 2)] = .green
        board.gems[Vector(x: 0, y: 3)] = .red
        
        let result = board.findMatches()
        XCTAssertEqual(result.count, 0)
    }
    
    func test_detectVerticalMatch3_returnsCoordsOfMatchingGems_alsoForFourInARow() {
        var board = Board()
        board.gems[Vector(x: 0, y: 0)] = .purple
        board.gems[Vector(x: 0, y: 1)] = .green
        board.gems[Vector(x: 0, y: 2)] = .green
        board.gems[Vector(x: 0, y: 3)] = .green
        board.gems[Vector(x: 0, y: 4)] = .green
        
        let result = board.findMatches()
        XCTAssertTrue(result.contains(Vector(x: 0, y: 1)))
        XCTAssertTrue(result.contains(Vector(x: 0, y: 2)))
        XCTAssertTrue(result.contains(Vector(x: 0, y: 3)))
        XCTAssertTrue(result.contains(Vector(x: 0, y: 4)))
    }
    
    // MARK: When matches are detected...
    func test_afterDetectingMatches_matchedGemsAreRemoved() {
        var board = Board()
        board.gems[Vector(x: 0, y: 0)] = .purple
        board.gems[Vector(x: 0, y: 1)] = .green
        board.gems[Vector(x: 0, y: 2)] = .green
        board.gems[Vector(x: 0, y: 3)] = .green
        board.gems[Vector(x: 0, y: 4)] = .green
        
        let updatedBoard = board.update()
        
        XCTAssertNil(updatedBoard[Vector(x: 0, y: 1)])
        XCTAssertNil(updatedBoard[Vector(x: 0, y: 2)])
        XCTAssertNil(updatedBoard[Vector(x: 0, y: 3)])
        XCTAssertNil(updatedBoard[Vector(x: 0, y: 4)])
    }
    
    func test_afterDetectingMatches_noNewGemsAreSpawned() {
        var board = Board()
        board.gems[Vector(x: 0, y: 0)] = .purple
        board.gems[Vector(x: 0, y: 1)] = .green
        board.gems[Vector(x: 0, y: 2)] = .green
        board.gems[Vector(x: 0, y: 3)] = .green
        
        let updatedBoard = board.update()
        
        XCTAssertEqual(updatedBoard.gems.count, 1)
    }
    
}

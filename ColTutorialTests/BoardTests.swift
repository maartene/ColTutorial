//
//  BoardTests.swift
//  ColTutorialTests
//
//  Created by Maarten Engels on 14/07/2024.
//

import Foundation
import XCTest
@testable import ColTutorial

final class BoardTests: XCTestCase {
    func test_gemFallsDown_when_spaceBelow_and_updateIsCalled() {
        var board = Board()
        board.gems[Vector(x: 3, y: 5)] = .green
        
        XCTAssertNil(board[Vector(x: 3, y: 4)])
        
        let updateBoard = board.update()
        
        XCTAssertNil(updateBoard[Vector(x: 3, y: 5)])
        XCTAssertEqual(updateBoard[Vector(x: 3, y: 4)], .green)
    }
    
    func test_gemDoesNotFall_belowBottom() {
        var board = Board()
        board.gems[Vector(x: 3, y: 0)] = .green
        
        let updatedBoard = board.update()
        
        XCTAssertEqual(updatedBoard[Vector(x: 3, y: 0)], .green)
        XCTAssertNil(updatedBoard[Vector(x: 3, y: -1)])
    }
    
    // MARK: Spawning new gems
    func test_aNewGem_spawnsWhenUpdatingANewBoard() {
        let board = Board()
        
        let updatedBoard = board.update()
        
        XCTAssertGreaterThan(updatedBoard.gems.count, 0)
    }
    
    func test_aNewGem_doesntSpawn_whenAnotherGemIsFalling() {
        var board = Board()
        board.gems[Vector(x: 0, y: 1)] = .red
        
        let updatedBoard = board.update()
        
        XCTAssertEqual(updatedBoard.gems.count, 1)
    }
    
    func test_threeNewGems_spawn_whenUpdatingAStableBoard() {
        var board = Board()
        board.gems[Vector(x: 0, y: 0)] = .red
        
        let updatedBoard = board.update()
        
        XCTAssertEqual(updatedBoard.gems.count, 4)
    }
    
    func test_threeNewGems_fall_as_a_stack() {
        let board = Board().update()
        
        let updatedBoard = board.update()
        
        XCTAssertTrue(updatedBoard.gems[Vector(x: 3, y: 12)] != nil)
        XCTAssertTrue(updatedBoard.gems[Vector(x: 3, y: 13)] != nil)
        XCTAssertTrue(updatedBoard.gems[Vector(x: 3, y: 14)] != nil)
    }
}

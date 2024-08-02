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
    
    // MARK: Control falling gems
    func test_whenLeftIsCalled_fallingGems_areShiftedOneColumnLeft() {
        let board = Board().update()
        
        let shiftedBoard = board.left()
        
        // The gems colours should be the same in the shifted boards shifted position as in the original board
        XCTAssertEqual(shiftedBoard[Vector(x: 2, y: 13)], board[Vector(x: 3, y: 13)])
        XCTAssertEqual(shiftedBoard[Vector(x: 2, y: 14)], board[Vector(x: 3, y: 14)])
        XCTAssertEqual(shiftedBoard[Vector(x: 2, y: 15)], board[Vector(x: 3, y: 15)])
                   
        // The original positions in the shifted board should now be empty
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 13)])
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 14)])
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 15)])
    }
    
    func test_whenLeftIsCalled_fallingGems_notInOriginalPosition_areShiftedOneColumnLeft() {
        let board = Board().update().update().update().update()
        
        let shiftedBoard = board.left()
        
        // The gems colours should be the same in the shifted boards shifted position as in the original board
        XCTAssertEqual(shiftedBoard[Vector(x: 2, y: 10)], board[Vector(x: 3, y: 10)])
        XCTAssertEqual(shiftedBoard[Vector(x: 2, y: 11)], board[Vector(x: 3, y: 11)])
        XCTAssertEqual(shiftedBoard[Vector(x: 2, y: 12)], board[Vector(x: 3, y: 12)])
                   
        // The original positions in the shifted board should now be empty
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 10)])
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 11)])
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 12)])
    }
    
    func test_whenLeftIsCalled_fallingGems_thatAreInColumn0_dontMoveLeft() {
        let board = Board().update().update().update().update()
        
        let shiftedBoard = board
            .left().left().left().left().left().left()
        
        XCTAssertNotNil(shiftedBoard[Vector(x: 0, y: 10)])
        XCTAssertNotNil(shiftedBoard[Vector(x: 0, y: 11)])
        XCTAssertNotNil(shiftedBoard[Vector(x: 0, y: 12)])
    }
    
    func test_shiftingColumnsLeft_cantOverlap_withExistingGems() {
        var board = Board()
        // stable gems
        board.gems[Vector(x: 0, y: 0)] = .green
        board.gems[Vector(x: 0, y: 1)] = .green
        board.gems[Vector(x: 0, y: 2)] = .red
        
        // falling gems
        board.gems[Vector(x: 1, y: 2)] = .yellow
        board.gems[Vector(x: 1, y: 3)] = .purple
        board.gems[Vector(x: 1, y: 4)] = .blue
        board.fallingStackBottom = Vector(x: 1, y: 2)
        
        let shiftedBoard = board.left()
        
        // board didn't change
        XCTAssertEqual(shiftedBoard[Vector(x: 1, y: 2)], board[Vector(x: 1, y: 2)])
        XCTAssertEqual(shiftedBoard[Vector(x: 1, y: 3)], board[Vector(x: 1, y: 3)])
        XCTAssertEqual(shiftedBoard[Vector(x: 1, y: 4)], board[Vector(x: 1, y: 4)])
    }
    
    func test_whenRightIsCalled_fallingGems_notInOriginalPosition_areShiftedOneColumnRight() {
        let board = Board().update().update().update().update()
        
        let shiftedBoard = board.right()
        
        // The gems colours should be the same in the shifted boards shifted position as in the original board
        XCTAssertEqual(shiftedBoard[Vector(x: 4, y: 10)], board[Vector(x: 3, y: 10)])
        XCTAssertEqual(shiftedBoard[Vector(x: 4, y: 11)], board[Vector(x: 3, y: 11)])
        XCTAssertEqual(shiftedBoard[Vector(x: 4, y: 12)], board[Vector(x: 3, y: 12)])
                   
        // The original positions in the shifted board should now be empty
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 10)])
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 11)])
        XCTAssertNil(shiftedBoard[Vector(x: 3, y: 12)])
    }
    
    func test_whenRightIsCalled_fallingGems_thatAreInColumn5_dontMoveRight() {
        let board = Board().update().update().update().update()
        
        let shiftedBoard = board
            .right().right().right().right().right().right()
        
        XCTAssertNotNil(shiftedBoard[Vector(x: 5, y: 10)])
        XCTAssertNotNil(shiftedBoard[Vector(x: 5, y: 11)])
        XCTAssertNotNil(shiftedBoard[Vector(x: 5, y: 12)])
    }
    
    func test_shiftingColumnsRight_cantOverlap_withExistingGems() {
        var board = Board()
        // stable gems
        board.gems[Vector(x: 5, y: 0)] = .green
        board.gems[Vector(x: 5, y: 1)] = .green
        board.gems[Vector(x: 5, y: 2)] = .red
        
        // falling gems
        board.gems[Vector(x: 4, y: 2)] = .yellow
        board.gems[Vector(x: 4, y: 3)] = .purple
        board.gems[Vector(x: 4, y: 4)] = .blue
        board.fallingStackBottom = Vector(x: 4, y: 2)
        
        let shiftedBoard = board.left()
        
        // board didn't change
        XCTAssertEqual(shiftedBoard[Vector(x: 4, y: 2)], board[Vector(x: 1, y: 2)])
        XCTAssertEqual(shiftedBoard[Vector(x: 4, y: 3)], board[Vector(x: 1, y: 3)])
        XCTAssertEqual(shiftedBoard[Vector(x: 4, y: 4)], board[Vector(x: 1, y: 4)])
    }
}

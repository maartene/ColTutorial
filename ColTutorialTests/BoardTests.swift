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
    private func compareStacks(board1: Board, stack1BottomGem: Vector, board2: Board, stack2BottomGem: Vector) {
        XCTAssertEqual(board1[stack1BottomGem], board2[stack2BottomGem])
        XCTAssertEqual(board1[stack1BottomGem + .up], board2[stack2BottomGem + .up])
        XCTAssertEqual(board1[stack1BottomGem + .up + .up], board2[stack2BottomGem + .up + .up])
    }
    
    private func compareStacksNil(board: Board, stackBottomGem: Vector) {
        XCTAssertNil(board[stackBottomGem])
        XCTAssertNil(board[stackBottomGem + .up])
        XCTAssertNil(board[stackBottomGem + .up + .up])
    }
    
    func test_whenLeftIsCalled_fallingGems_areShiftedOneColumnLeft() {
        let board = Board().update()
        
        let shiftedBoard = board.left()
        
        // The gems colours should be the same in the shifted boards shifted position as in the original board
        compareStacks(board1: shiftedBoard, stack1BottomGem: Vector(x: 2, y: 13), board2: board, stack2BottomGem: Vector(x: 3, y: 13))
                   
        // The original positions in the shifted board should now be empty
        compareStacksNil(board: shiftedBoard, stackBottomGem: Vector(x: 3, y: 13))
    }
    
    func test_whenLeftIsCalled_fallingGems_notInOriginalPosition_areShiftedOneColumnLeft() {
        let board = Board().update().update().update().update()
        
        let shiftedBoard = board.left()
        
        // The gems colours should be the same in the shifted boards shifted position as in the original board
        compareStacks(board1: shiftedBoard, stack1BottomGem: Vector(x: 2, y: 10), board2: board, stack2BottomGem: Vector(x: 3, y: 10))
                   
        // The original positions in the shifted board should now be empty
        compareStacksNil(board: shiftedBoard, stackBottomGem: Vector(x: 3, y: 10))
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
        compareStacks(board1: shiftedBoard, stack1BottomGem: Vector(x: 1, y: 2), board2: board, stack2BottomGem: Vector(x: 1, y: 2))
    }
    
    func test_whenRightIsCalled_fallingGems_notInOriginalPosition_areShiftedOneColumnRight() {
        let board = Board().update().update().update().update()
        
        let shiftedBoard = board.right()
        
        // The gems colours should be the same in the shifted boards shifted position as in the original board
        compareStacks(board1: shiftedBoard, stack1BottomGem: Vector(x: 4, y: 10), board2: board, stack2BottomGem: Vector(x: 3, y: 10))
                   
        // The original positions in the shifted board should now be empty
        compareStacksNil(board: shiftedBoard, stackBottomGem: Vector(x: 3, y: 10))
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
        
        let shiftedBoard = board.right()
        
        // board didn't change
        compareStacks(board1: shiftedBoard, stack1BottomGem: Vector(x: 4, y: 2), board2: board, stack2BottomGem: Vector(x: 4, y: 2))
    }
    
    func test_whenANewStackFalls_fallingStackBottom_isReset() {
        var board = Board()
        
        while board.gems.count < 6 {
            board = board.update()
        }
        
        XCTAssertEqual(board.fallingStackBottom, Vector(x: 3, y: 13))
    }
    
    func test_cycle() {
        let board = Board().update()
        guard let originalGem1 = board[board.fallingStackBottom],
              let originalGem2 = board[board.fallingStackBottom + .up],
              let originalGem3 = board[board.fallingStackBottom + .up + .up]
        else {
            XCTFail("Expected to find three gems.")
            return
        }
        
        let cycledBoard = board.cycle()
        
        guard let cycledGem1 = cycledBoard[board.fallingStackBottom],
              let cycledGem2 = cycledBoard[board.fallingStackBottom + .up],
              let cycledGem3 = cycledBoard[board.fallingStackBottom + .up + .up]
        else {
            XCTFail("Expected to find three gems.")
            return
        }
        
        XCTAssertEqual(cycledGem1, originalGem2)
        XCTAssertEqual(cycledGem2, originalGem3)
        XCTAssertEqual(cycledGem3, originalGem1)
    }
    
    func test_afterCyclingThreeTimes_wereBackToStart() {
        let board = Board().update()
        guard let originalGem1 = board[board.fallingStackBottom],
              let originalGem2 = board[board.fallingStackBottom + .up],
              let originalGem3 = board[board.fallingStackBottom + .up + .up]
        else {
            XCTFail("Expected to find three gems.")
            return
        }
        
        let cycledBoard = board.cycle().cycle().cycle()
        
        guard let cycledGem1 = cycledBoard[board.fallingStackBottom],
              let cycledGem2 = cycledBoard[board.fallingStackBottom + .up],
              let cycledGem3 = cycledBoard[board.fallingStackBottom + .up + .up]
        else {
            XCTFail("Expected to find three gems.")
            return
        }
        
        XCTAssertEqual(cycledGem1, originalGem1)
        XCTAssertEqual(cycledGem2, originalGem2)
        XCTAssertEqual(cycledGem3, originalGem3)
    }
    
    // MARK: Win/lose conditions
    func test_whenYouReachTheTopOfScreen_youLose() {
        var board = Board()
        for y in 0 ... board.rowCount {
            board.gems[Vector(x: 3, y: y)] = Gem.allCases[y % Gem.allCases.count]
        }
        
        let updatedBoard = board.update()
        
        XCTAssertEqual(updatedBoard.state, .loss)
    }
    
    func test_whenAGameHasJustStarted_itIsInState_inProgress() {
        let board = Board()
        
        let updatedBoard = board.update()
        
        XCTAssertEqual(updatedBoard.state, .inProgress)
    }
    
    func test_whenAGameIsLost_youCannotControlGems() {
        var board = Board()
        for y in 0 ... board.rowCount {
            board.gems[Vector(x: 3, y: y)] = Gem.allCases[y % Gem.allCases.count]
        }
        let lossBoard = board.update()
        XCTAssertEqual(lossBoard.state, .loss)
        
        let leftBoard = lossBoard.left()
        XCTAssertNil(leftBoard[Vector(x: 2, y: 13)])
        XCTAssertNotNil(leftBoard[Vector(x: 3, y: 13)])
        
        let rightBoard = lossBoard.right()
        XCTAssertNil(rightBoard[Vector(x: 4, y: 13)])
        XCTAssertNotNil(rightBoard[Vector(x: 3, y: 13)])
        
        // Cycle
        let cycledBoard = lossBoard.cycle()
        XCTAssertEqual(cycledBoard[Vector(x: 3, y: 13)], lossBoard[Vector(x: 3, y: 13)])
    }
}

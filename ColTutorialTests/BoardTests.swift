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
}

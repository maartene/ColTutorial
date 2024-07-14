//
//  Vector.swift
//  ColTutorial
//
//  Created by Maarten Engels on 14/07/2024.
//

import Foundation

struct Vector {
    let x: Int
    let y: Int
}

// MARK: Vector maths
extension Vector {
    static func +(lhs: Vector, rhs: Vector) -> Vector {
        Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

// MARK: Basic values
extension Vector {
    static var down: Vector {
        Vector(x: 0, y: -1)
    }
}

extension Vector: Hashable { }

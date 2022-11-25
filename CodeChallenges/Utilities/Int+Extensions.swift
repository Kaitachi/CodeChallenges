//
//  Int+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-25.
//

import Foundation

// MARK: - Type Aliases
typealias Coordinate = (x: Int, y: Int)
typealias Grid2D = [[Int?]]


// MARK: - Int Methods
extension Int {
    func bitDensity(using total: Int) -> Int {
        return (Double(total)/2 <= Double(self)).intValue
    }
}


// MARK: - UInt64 Methods
extension UInt64 {
    var msb: UInt64 {
        var caret: UInt64 = UInt64(1)
        
        // Move caret to MSB
        while (caret <= self && caret << 1 <= self) {
            caret = caret << 1
        }
        
        return caret
    }
}

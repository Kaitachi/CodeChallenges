//
//  Int+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-25.
//

import Foundation

// MARK: - Type Aliases
typealias Coordinate = (x: Int, y: Int)
typealias Vector = (start: Coordinate, end: Coordinate)


// MARK: - Int Methods
extension Int {
    func bitDensity(using total: Int) -> Int {
        return (Double(total)/2 <= Double(self)).intValue
    }
    
    var length: Int {
        get {
            guard self != 0 else {
                return 1
            }
            let sgn: Int = (self > 0) ? 0 : 1
            
            return 1 + Int(log(Double(abs(self)))/log(Double(10))) + sgn
        }
    }
}


// MARK: - [Int] Methods
extension [Int] {
    static func orthogonalIndices(for size: Int) -> [[Int]] {
        let rows = stride(from: 0, to: size * size, by: size)
            .map { start in
                return Array(stride(from: start, to: start + size, by: 1))
            }
        
        let columns = stride(from: 0, to: size, by: 1)
            .map { start in
                return Array(stride(from: start, to: size * size, by: size))
            }
        
        return rows + columns
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

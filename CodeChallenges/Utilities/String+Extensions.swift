//
//  String+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-25.
//

import Foundation

// MARK: - String Methods
extension String {
    var binaryValue: UInt64? {
        return UInt64(self, radix: 2)
    }
    
    var directionalCoordinate: Coordinate? {
        let direction = self.components(separatedBy: .whitespaces)
        
        switch direction[0] {
        case "forward":
            return (x: Int(direction[1])!, y: 0)
            
        case "backward":
            return (x: -1 * Int(direction[1])!, y: 0)
            
        case "up":
            return (x: 0, y: Int(direction[1])!)
            
        case "down":
            return (x: 0, y: -1 * Int(direction[1])!)
            
        default:
            // Invalid direction input!
            return nil
        }
    }
    
    var cartesianCoordinate: Coordinate? {
        let components = self.components(separatedBy: .punctuationCharacters)
            .compactMap { Int($0) }
        
        if components.count != 2 {
            return nil
        }
        
        return (x: components[0], y: components[1])
    }
    
    var vectorValue: Vector? {
        let components = self.components(separatedBy: "->")
            .compactMap { $0.trimmingCharacters(in: .whitespaces) }
            .compactMap { $0.cartesianCoordinate }
        
        if components.count != 2 {
            return nil
        }
        
        return (start: components[0], end: components[1])
    }
        
    func leftPadding(toLength: Int, withPad: String, startingAt: Int) -> String {
        String(String(reversed()).padding(toLength: toLength, withPad: withPad, startingAt: startingAt).reversed())
    }
}

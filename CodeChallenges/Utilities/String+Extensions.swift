//
//  String+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-25.
//

import Foundation

// MARK: - String Methods
extension String {
    func byteArray() -> [UInt64] {
        return self.components(separatedBy: .newlines)
            .compactMap { UInt64($0, radix: 2) }
    }
    
    var binaryUInt64Value: UInt64 {
        return UInt64(self, radix: 2) ?? 0
    }
    
    func directionalCoordinates() -> [Coordinate] {
        return self.components(separatedBy: .newlines)
            .compactMap {
                let direction = $0.components(separatedBy: .whitespaces)
                
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
    }
    
    func leftPadding(toLength: Int, withPad: String, startingAt: Int) -> String {
        String(String(reversed()).padding(toLength: toLength, withPad: withPad, startingAt: startingAt).reversed())
    }
}

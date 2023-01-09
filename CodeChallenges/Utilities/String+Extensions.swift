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
    
    // TODO: Remove this method! (used in AOC2021 Day 02)
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
    
    // Kudos to @Ondrej Stocek from StackOverflow for the following function!
    // https://stackoverflow.com/a/40741560
    func grid(columns length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let startIndex = self.index(self.startIndex, offsetBy: $0)
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[startIndex..<endIndex])
        }
    }
    
    func evaluate(with dictionary: Any?) -> Any? {
        return NSExpression(format: self).expressionValue(with: dictionary, context: nil)
    }
    
    func leftPadding(toLength length: Int, withPad padding: String, startingAt position: Int) -> String {
        String(String(reversed()).padding(toLength: length, withPad: padding, startingAt: position).reversed())
    }
    
    func cardinalDirection(default steps: Int = 1, directions: [String: CardinalDirection] = CardinalDirection.defaults) -> Direction? {
        let parts = self.components(separatedBy: .whitespaces)
                
        guard parts.count > 0,
              !parts[0].isEmpty else {
            return nil
        }
    
        // Determine how many steps to go in this direction
        let steps = (parts.count > 1)
            ? (Int(parts[1]) ?? steps)
            : steps
    
        // Determine direction to go
        switch directions[parts[0], default: .unknown] {
        case .N: return .North(amount: steps)
        case .NE: return .NorthEast(amount: steps)
        case .E: return .East(amount: steps)
        case .SE: return .SouthEast(amount: steps)
        case .S: return .South(amount: steps)
        case .SW: return .SouthWest(amount: steps)
        case .W: return .West(amount: steps)
        case .NW: return .NorthWest(amount: steps)
        default: return .unknown
        }
    }
}

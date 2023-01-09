//
//  CardinalDirection.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2023-01-09.
//

import Foundation

public enum CardinalDirection {
    case N
    case NE
    case E
    case SE
    case S
    case SW
    case W
    case NW
    case unknown

    public static var defaults: [String: CardinalDirection] {
        get {
            return [
                "N": .N,
                "NE": .NE,
                "E": .E,
                "SE": .SE,
                "S": .S,
                "SW": .SW,
                "W": .W,
                "NW": .NW
            ]
        }
    }
}



public enum Direction {
    case unknown
    case North(amount: Int)
    case NorthEast(amount: Int)
    case East(amount: Int)
    case SouthEast(amount: Int)
    case South(amount: Int)
    case SouthWest(amount: Int)
    case West(amount: Int)
    case NorthWest(amount: Int)

    public init?(from instruction: String, steps: Int = 1, directions: [String: CardinalDirection] = CardinalDirection.defaults) {
        let parts = instruction.components(separatedBy: .whitespaces)
        
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
        case .N: self = .North(amount: steps)
        case .NE: self = .NorthEast(amount: steps)
        case .E: self = .East(amount: steps)
        case .SE: self = .SouthEast(amount: steps)
        case .S: self = .South(amount: steps)
        case .SW: self = .SouthWest(amount: steps)
        case .W: self = .West(amount: steps)
        case .NW: self = .NorthWest(amount: steps)
        default: self = .unknown
        }
    }
}

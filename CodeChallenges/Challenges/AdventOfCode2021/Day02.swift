//
//  Day02.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-24.
//

import ChallengeBase

extension AdventOfCode2021 {
    class Day02 : AdventOfCode2021, Solution {
        // MARK: - Type Aliases
        typealias Input = [Coordinate]
        typealias Output = Int
        
        
        // MARK: - Properties
        var testCases: [TestCase<Input, Output>] = []
        var selectedResourceSets: [String] = []
        var selectedAlgorithms: [Algorithms] = []
        
        
        // MARK: - Initializers
        init(datasets: [String] = [], algorithms: [Algorithms] = []) {
            self.selectedResourceSets = datasets
            self.selectedAlgorithms = algorithms
        }
        
        
        // MARK: - Solution Methods
        // Step 1: Assemble
        func assemble(_ input: String, _ output: String? = nil) -> (Input, Output?) {
            let directions = input.directionalCoordinates()
            
            let finalPosition = output?.integerList()[0]
            
            return (directions, finalPosition)
        }
        
        // Step 2: Act
        func act(_ input: Input, algorithm: Algorithms) -> Output {
            switch algorithm {
            case .part01:
                return part01(input)
            case .part02:
                return part02(input)
            }
        }
        
        
        // MARK: - Logic Methods
        func part01(_ directions: Input) -> Output {
            // Let's store our current position
            var position: Coordinate = (x: 0, y: 0)
            
            // Iterate through given directions
            // Y-component of coordinate should be inverted!
            for direction in directions {
                position.x += direction.x
                position.y -= direction.y
            }
            
            // Finally, multiply our coordinate values
            return position.x * position.y
        }
        
        func part02(_ directions: Input) -> Output {
            // Let's store our current position
            var position: Coordinate = (x: 0, y: 0)
            var aim: Int = 0
            
            // Iterate through given directions
            // Y-component of coordinate should be inverted!
            for direction in directions {
                position.x += direction.x
                position.y -= (direction.x * aim)
                
                aim += direction.y
            }
            
            return position.x * position.y
        }
    }
}

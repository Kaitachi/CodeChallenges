//
// 
//  Day05.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-25.
//
//

import ChallengeBase

extension AdventOfCode2021 {
    class Day05 : AdventOfCode2021, Solution {
        // MARK: - Type Aliases
        typealias Input = [Vector]
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
            let vectors = input
                .components(separatedBy: .newlines)
                .compactMap { $0.vectorValue }
            
            let formattedOutput = output?.integerList()[0]
            
            return (vectors, formattedOutput)
        }
        
        // Step 2: Activate
        func activate(_ input: Input, algorithm: Algorithms) -> Output {
            switch algorithm {
            case .part01:
                return part01(input)
            case .part02:
                return part02(input)
            }
        }
        
        
        // MARK: - Logic Methods
        func part01(_ vectors: Input) -> Output {
            var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
            
            let guys = vectors
                .filter { AdventOfCode2021.Day05.direction(for: $0) != .diagonal }
            
            for guy in guys {
                for point in AdventOfCode2021.Day05.getPoints(through: guy) {
                    grid[point.x][point.y] += 1
                }
            }
                        
            return grid.joined().filter { $0 > 1 }.count
        }
        
        func part02(_ inputData: Input) -> Output {
            return -1
        }
        
        
        // MARK: - Helper Methods
        static func direction(for vector: Vector) -> Direction {
            if vector.start.y == vector.end.y {
                return .horizontal
            } else if vector.start.x == vector.end.x {
                return .vertical
            } else {
                return .diagonal
            }
        }
        
        static func getPoints(through vector: Vector) -> [Coordinate] {
            var points: [Coordinate] = [Coordinate]()
            
            switch AdventOfCode2021.Day05.direction(for: vector) {
            case .horizontal:
                var start: Int
                var end: Int
                
                if vector.end.x < vector.start.x {
                    start = vector.end.x
                    end = vector.start.x
                } else {
                    start = vector.start.x
                    end = vector.end.x
                }
                
                stride(from: start, through: end, by: 1)
                    .forEach { points.append((x: $0, y: vector.start.y)) }

            case .vertical:
                var start: Int
                var end: Int
                
                if vector.end.y < vector.start.y {
                    start = vector.end.y
                    end = vector.start.y
                } else {
                    start = vector.start.y
                    end = vector.end.y
                }
                
                stride(from: start, through: end, by: 1)
                    .forEach { points.append((x: vector.start.x, y: $0)) }

                
            case .diagonal:
                print("DIAGONAL MOVEMENT \(vector)")
            }
            
            return points
        }
    }
}

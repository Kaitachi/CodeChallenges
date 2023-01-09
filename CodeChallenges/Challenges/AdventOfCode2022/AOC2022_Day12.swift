//
// 
//  AOC2022_Day12.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-12.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day12 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [[String]]
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
        func assemble(_ rawInput: String, _ rawOutput: String? = nil) -> (Input, Output?) {
            let formattedInput: Input = rawInput.components(separatedBy: .newlines)
                .compactMap { line in
                    guard !line.isEmpty else {
                        return nil
                    }

                    return line.map { String($0) }
                }
                        
            let formattedOutput = rawOutput?.integerList()[0]
                        
            return (formattedInput, formattedOutput)
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
        func part01(_ heightmap: Input) -> Output {
            let start: Cell2DIndex = heightmap.index(of: MapMarker.start.rawValue)!
            let target: Cell2DIndex = heightmap.index(of: MapMarker.target.rawValue)!

            return AdventOfCode2022.Day12.shortestDistance(from: start, to: target, in: heightmap)!
        }
        
        func part02(_ heightmap: Input) -> Output {
            let target: Cell2DIndex = heightmap.index(of: MapMarker.target.rawValue)!
            
            return heightmap.indices(of: "a").compactMap { start in
                AdventOfCode2022.Day12.shortestDistance(from: start, to: target, in: heightmap)
            }
            .reduce(Int.max) { min($0, $1) }
        }
        
        
        // MARK: - Helper Methods
        enum MapMarker: String {
            case start = "S" // transforms to 96 in intMap
            case target = "E" // transforms to 123 in intMap
        }
        
        enum NodeVisit: String {
            case unvisited = "."
            case north = "^"
            case south = "v"
            case east = ">"
            case west = "<"
        }
        
        static func shortestDistance(from start: Cell2DIndex, to goal: Cell2DIndex, in heightmap: Input) -> Int? {
//            print("heightmap:")
//            heightmap.describe()
                        
            var levelmap: [[Int]] = heightmap.map { line in
                line.map { Int(Character($0).asciiValue!) }
            }
            
            // Change values for start and target positions (to make our logic somewhat easier)
            levelmap[start.row][start.col] = Int(Character("a").asciiValue!)
            levelmap[goal.row][goal.col] = Int(Character("z").asciiValue!)
            
//            print("levelmap:")
//            levelmap.describe()
            
            var visitmap: [[[String: Cell2D<Int>]?]] = heightmap.map { line in
                line.map { cell in return nil }
            }
            
//            print("visitmap:")
//            visitmap.describe()
                        
            var locationsToVisit: [Cell2DIndex] = [start]
            
            for i in stride(from: 0, through: heightmap.size, by: 1) {
                var newLocations: [Cell2DIndex] = [Cell2DIndex]()
                
//                print("=== START ROUND \(i) ===")
                
                for cursor in locationsToVisit {
                    guard visitmap[cursor.row][cursor.col] == nil else {
                        continue
                    }
                    
                    let currentLetter: String = heightmap[cursor.row][cursor.col]
                    let currentLevel: Int = levelmap[cursor.row][cursor.col]
//                    print("> [\(i)] Convolving at location \(cursor)\n\n")
                    
                    let currentCell: Cell2D<Int> = Cell2D(row: cursor.row, col: cursor.col, value: i)
                    
                    visitmap[cursor.row][cursor.col] = [currentLetter: currentCell]
                    
                    let candidates = levelmap.convolve(with: Kernels.taxicab, at: cursor) { pairs in
                        pairs.map { (matrix: $0, kernel: $1) }
//                            .map { pair in print("convolved pair: \(pair)"); return pair }
                            .filter { pair in pair.kernel.value! == 1 } // Masking to obtain legal locations only
                            .filter { pair in visitmap[pair.matrix.row][pair.matrix.col] == nil } // Gathering list of unvisited places
                            .filter { pair in (pair.matrix.value! - currentLevel) <= 1 } // Moving only to places where height is one number taller or less
                    }
        
//                    print("Candidate locations to move next:")
//                    candidates.describe()
                    
                    // NOTE: possibility of duplicates added to newLocations
                    newLocations += candidates.map { (row: $0.matrix.row, col: $0.matrix.col) }
                }
                
//                // Bunch of print statements
//                print("heightmap:")
//                heightmap.describe()
//
//                print("levelmap:")
//                levelmap.describe()
//
//                print("visitmap:")
//                visitmap.describe()
//
//                print("newLocations:")
//                newLocations.describe()
//
//                print("=== END ROUND \(i) ===")
                
                // Overwrite locations to visit
                locationsToVisit = newLocations
            }
                                                
            if let journey = visitmap[goal.row][goal.col] {
                return journey.values.first!.value
            } else {
                // Something went wrong...
//                print("cell: \(visitmap[goal.row][goal.col])")
                
                return nil
            }
        }
    }
}

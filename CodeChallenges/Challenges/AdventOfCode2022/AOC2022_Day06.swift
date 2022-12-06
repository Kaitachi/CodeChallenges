//
// 
//  AOC2022_Day06.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-05.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day06 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = String
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
            let formattedInput = rawInput
            
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
        func part01(_ signal: Input) -> Output {
            return AdventOfCode2022.Day06.findFirstUniqueSubstring(for: signal, length: 4) ?? -1
        }
        
        func part02(_ signal: Input) -> Output {
            return AdventOfCode2022.Day06.findFirstUniqueSubstring(for: signal, length: 14) ?? -1
        }
        
        
        // MARK: - Helper Methods
        static func findFirstUniqueSubstring(for signal: String, length: Int) -> Int? {
            for i in 0..<(signal.count-length) {
                let startMarker = signal.index(signal.startIndex, offsetBy: i)
                let endMarker = signal.index(signal.startIndex, offsetBy: i + length - 1)
                                
                if Set(signal[startMarker...endMarker]).count == length {
                    return i + length
                }
            }
            
            // Unique substring not found
            return nil
        }
    }
}

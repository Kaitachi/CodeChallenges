//
// 
//  Day01.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-01.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day01 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [[Int]]
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
                .components(separatedBy: "\n\n")
                .compactMap { $0.integerList() }
            
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
        func part01(_ elves: Input) -> Output {
            let mostCalories: [Int] = AdventOfCode2022.Day01.calorieCount(elves)
                .sorted(by: > )

            return mostCalories.first!
        }
        
        func part02(_ elves: Input) -> Output {
            let topThreeCalories: [Int] = Array(AdventOfCode2022.Day01.calorieCount(elves)
                .sorted(by: > )[..<3])
            
            return topThreeCalories.reduce(0, +)
        }
        
        
        static func calorieCount(_ elves: Input) -> [Int] {
            // Get Calorie Count for each Elf
            return elves
                .compactMap { $0.reduce(0, +) }
        }
    }
}

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
        typealias Input = [Int]
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
            let formattedInput = input.integerList()
            
            let formattedOutput = output?.integerList()[0]
            
            return (formattedInput, formattedOutput)
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
        func part01(_ inputData: Input) -> Output {
            return -1
        }
        
        func part02(_ inputData: Input) -> Output {
            return -1
        }
    }
}

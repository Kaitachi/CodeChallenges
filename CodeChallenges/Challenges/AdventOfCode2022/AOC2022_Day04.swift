//
// 
//  AOC2022_Day04.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-04.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day04 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [(elf1: [Int], elf2: [Int])]
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
                    
                    let elves = line.components(separatedBy: ",")
                    
                    let elf1 = elves[0].components(separatedBy: "-")
                        .compactMap { Int($0) }
                    let elf2 = elves[1].components(separatedBy: "-")
                        .compactMap { Int($0) }
                    
                    return (elf1: elf1, elf2: elf2)
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
        func part01(_ inputData: Input) -> Output {
            var overlappingAssignments: Int = 0
//            print(inputData)
            
            for line in inputData {
                let assign1: Set<Int> = Set(line.elf1[0]...line.elf1[1])
                let assign2: Set<Int> = Set(line.elf2[0]...line.elf2[1])
                
//                print("=====")
//                print(assign1)
//                print(assign2)
                
                let isOverlap1: Bool = assign1.subtracting(assign2).isEmpty
                let isOverlap2: Bool = assign2.subtracting(assign1).isEmpty
                
                overlappingAssignments += (isOverlap1 || isOverlap2) ? 1 : 0
            }
            
            return overlappingAssignments
        }
        
        func part02(_ inputData: Input) -> Output {
            return -1
        }
    }
}

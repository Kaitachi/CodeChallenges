//
//  Day03.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-24.
//

import Foundation
import ChallengeBase

extension AdventOfCode2021 {
    class Day03 : AdventOfCode2021, Solution {
        // MARK: - Type Aliases
        typealias Input = [String]
        typealias Output = Int64
        
        
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
            let byteArray = input.components(separatedBy: .newlines)
                .filter { $0 != "" }
            
            let powerConsumption = Int64(output?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
            
            return (byteArray, powerConsumption)
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
        func part01(_ byteArray: Input) -> Output {
            // Calculate the most common bit for each column
            let commonByteString = AdventOfCode2021.Day03.mostCommonCharacter(in: byteArray)
                        
            let gammaRate: UInt16 = UInt16(commonByteString, radix: 2)!
            let epsilonRate: UInt16 = ~gammaRate & AdventOfCode2021.Day03.getTrailingNBits(n: byteArray.first!.count)
            
            return Int64(gammaRate) * Int64(epsilonRate)
        }
        
        func part02(_ directions: Input) -> Output {
            return -1
        }
        
        
        // MARK: - Helper Methods
        static func mostCommonCharacter(in array: [String]) -> String {
            var characterFrequencies: [Int: [Character: Int]] = [Int: [Character: Int]]() // [position: [char: count]]
            var mostCommonCharacters: [Character] = [Character]()
            
            // For each line,
            for line in array {
                // Add one to the current count of each character
                for char in Array(line).enumerated() {
                    // Initialize offset if it does not exist
                    if characterFrequencies[char.offset] == nil {
                        characterFrequencies[char.offset] = [Character: Int]()
                    }
                    
                    // Initialize character for this offset if it does not exist
                    if characterFrequencies[char.offset]![char.element] == nil {
                        characterFrequencies[char.offset]![char.element] = 0
                    }
                    
                    // Since we have already made sure that all indices exist, we can force unwrap these guys
                    characterFrequencies[char.offset]![char.element]! += 1
                }
            }
                        
            // Sort dictionary keys before doing anything else
            let charactersByOffset = characterFrequencies
                .sorted { $0.key < $1.key }
                .map { $0.value }
                        
            // Iterate through our dictionary to obtain the most common character for each offset
            for characters in charactersByOffset {
                // Sort each character list by its count
                let sorted = characters
                    .sorted { $0.value > $1.value }
                    .first!.key

                mostCommonCharacters.append(sorted)
            }
                        
            return String(mostCommonCharacters)
        }
        
        static func getTrailingNBits(n: Int) -> UInt16 {
            return UInt16(truncating: pow(2, n) as NSDecimalNumber) - 1
        }
    }
}

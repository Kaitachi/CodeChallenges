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
        typealias Input = [UInt64]
        typealias Output = UInt64
        
        
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
            let byteArray = input.byteArray()
            
            let powerConsumption = UInt64(output?.integerList()[0] ?? 0)
            
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
            let mask = byteArray.reduce(0) { $0 | $1 }
            let length = String(mask, radix: 2).count
            let size = byteArray.count
            
            // Remember: mostSignificantBits[0] is LSB
            let mostSignificantBits = AdventOfCode2021.Day03.trueBitCount(in: byteArray, mask: mask)
                .map { String(($0 >= size/2).intValue) }
                .reversed()
                .joined()
                .binaryUInt64Value
            
            let gammaRate: UInt64 = mostSignificantBits
            let epsilonRate: UInt64 = ~gammaRate & mask

//            print("mask:      \(String(mask, radix: 2))")
//            print("bits:      \(String(mostSignificantBits, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//            print("gammaRate: \(String(gammaRate, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0)) = \(gammaRate)")
//            print("epsilRate: \(String(epsilonRate, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0)) = \(epsilonRate)")

            return gammaRate * epsilonRate
        }
        
        func part02(_ directions: Input) -> Output {
            return 0
        }
        
        
        // MARK: - Helper Methods
        static func trueBitCount(in array: Input, mask: UInt64) -> [Int] {
            var result: [Int] = [Int]()
            var position: UInt64 = UInt64(1)
            
            // Starting from the rightmost position, count the bits that are "true"
            while (0 < mask & position && position <= mask) {
                let matches = array.filter { $0 & position > 0 }
                result.append(matches.count)
                                
                // Move position to next bit
                position = position << 1
            }
            
            return result
        }
    }
}

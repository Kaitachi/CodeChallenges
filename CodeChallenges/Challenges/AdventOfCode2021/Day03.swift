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
//            let length = String(mask, radix: 2).count
            let size = byteArray.count
            
            // Remember: mostSignificantBits[0] is LSB
            let mostSignificantBits = AdventOfCode2021.Day03.trueBitCount(in: byteArray, mask: mask)
                .map { String(($0 >= size/2).intValue) }
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
        
        func part02(_ byteArray: Input) -> Output {
            var filtered = byteArray
            let mask = byteArray.reduce(0) { $0 | $1 }
            let length = String(mask, radix: 2).count
            var caret: UInt64 = mask.msb
            
            var o2Gen: UInt64 = UInt64(0)
            var co2Scrub: UInt64 = UInt64(0)
            
            // Starting from the leftmost position, find MSB for each bit column to determine o2Gen
            while (0 < caret && 1 < filtered.count) {
//                print(filtered)
                
                let MSB = AdventOfCode2021.Day03.trueBitCount(in: filtered, mask: mask, filter: caret)
                    .map { String((Double($0) >= Double(filtered.count)/2).intValue) } // Determines MSB for caret position
                    .joined()
                    .binaryUInt64Value

//                print("caret:  \(String(caret, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//                print("MSB:    \(String(MSB, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
                
                filtered = filtered.filter { ($0 & caret) ^ MSB == 0 }
                
//                print(filtered)
//                print()
                // Move caret to next bit
                caret = caret >> 1
            }
            
            o2Gen = filtered[0]
            
            // Reset variables
            filtered = byteArray
            caret = mask.msb
            
            // Starting from the leftmost position, find LSB for each bit column to determine co2Scrub
            while (0 < caret && 1 < filtered.count) {
//                print(filtered)
                
                let LSB = AdventOfCode2021.Day03.trueBitCount(in: filtered, mask: mask, filter: caret)
                    .map { String((Double($0) >= Double(filtered.count)/2).intValue) } // Determines LSB for caret position
                    .joined()
                    .binaryUInt64Value ^ caret

                filtered = filtered.filter { ($0 & caret) ^ LSB == 0 }

//                print("caret:  \(String(caret, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//                print("LSB:    \(String(LSB, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//                print(filtered)
//                print()
                
                // Move caret to next bit
                caret = caret >> 1
            }

            co2Scrub = filtered[0]
            
//            print("mask:     \(String(mask, radix: 2))")
//            print("o2Gen:    \(o2Gen)")
//            print("co2Scrub: \(co2Scrub)")

            return o2Gen * co2Scrub
        }
        
        
        // MARK: - Helper Methods
        static func trueBitCount(in array: Input, mask: UInt64, filter: UInt64? = nil) -> [Int] {
            var result: [Int] = [Int]()
            let filter: UInt64 = filter ?? mask
            var caret: UInt64 = mask.msb
            
            // Starting from the leftmost bit, count the bits that are "true" in each column
            while (0 < caret) {
                let matches = array.filter { $0 & caret & filter > 0 }
                result.append(matches.count)
                                
                // Move caret to next bit
                caret = caret >> 1
            }
            
//            print("trueBitCount: \(result)")
            
            return result
        }
    }
}

//
//  Day03.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-24.
//

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
        func assemble(_ rawInput: String, _ rawOutput: String? = nil) -> (Input, Output?) {
            let byteArray = rawInput
                .components(separatedBy: .newlines)
                .compactMap { $0.binaryValue }
            
            let powerConsumption = UInt64(rawOutput?.integerList()[0] ?? 0)
            
            return (byteArray, powerConsumption)
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
        func part01(_ byteArray: Input) -> Output {
            let mask = byteArray.reduce(0) { $0 | $1 }
//            let length = String(mask, radix: 2).count
            
            let mostSignificantBits = AdventOfCode2021.Day03.mostSignificantBits(byteArray, mask: mask)
            
            let gammaRate: UInt64 = mostSignificantBits
            let epsilonRate: UInt64 = ~gammaRate & mask

//            print("mask:      \(String(mask, radix: 2))")
//            print("bits:      \(String(mostSignificantBits, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//            print("gammaRate: \(String(gammaRate, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0)) = \(gammaRate)")
//            print("epsilRate: \(String(epsilonRate, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0)) = \(epsilonRate)")

            return gammaRate * epsilonRate
        }
        
        func part02(_ byteArray: Input) -> Output {
            let mask = byteArray.reduce(0) { $0 | $1 }
                        
            let o2Gen = AdventOfCode2021.Day03.filterUInt64List(byteArray, mask: mask, prioritize: 0)[0]
            let co2Scrub = AdventOfCode2021.Day03.filterUInt64List(byteArray, mask: mask, prioritize: mask)[0]
                        
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
            
            return result
        }
        
        static func mostSignificantBits(_ array: Input, mask: UInt64, filter: UInt64? = nil) -> UInt64 {
            return AdventOfCode2021.Day03.trueBitCount(in: array, mask: mask, filter: filter)
                .map { String($0.bitDensity(using: array.count)) }
                .joined()
                .binaryValue!
        }
        
        static func filterUInt64List(_ array: Input, mask: UInt64, prioritize: UInt64) -> Input {
//            let length = String(mask, radix: 2).count
            var filtered = array
            var caret = mask.msb
            
            // Starting from the leftmost position, find MSB for each bit column and filter based on current significance
            while (0 < caret && 1 < filtered.count) {
//                print(filtered)
                
                let MSB = AdventOfCode2021.Day03.mostSignificantBits(filtered, mask: mask, filter: caret)
        
                // Numbers XORd
                filtered = filtered.filter { ($0 & caret) ^ (prioritize & caret) ^ MSB == 0 }

//                print("mask:   \(String(mask, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//                print("thing:  \(String(thing, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//                print("caret:  \(String(caret, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//                print("MSB:    \(String(MSB, radix: 2).leftPadding(toLength: length, withPad: "0", startingAt: 0))")
//                print(filtered)
//                print()
                
                // Move caret to next bit
                caret = caret >> 1
            }

            return filtered
        }
    }
}

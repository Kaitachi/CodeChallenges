//
// 
//  AOC2022_Day03.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-03.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day03 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [(l: String, r: String)]
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
            let formattedInput = rawInput.components(separatedBy: .newlines)
                .compactMap { line in
                    let compartmentIndex = line.index(line.startIndex, offsetBy: line.count / 2)
                    return (l: String(line[..<compartmentIndex]), r: String(line[compartmentIndex...]))
                }
                //.filter { $0 != [] }
            
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
            var result: Int = 0
            
            fillItemValues()
            
            for rucksack in elves {
                if let commonItem = Set(rucksack.l).intersection(Set(rucksack.r)).first {
//                    print("[\(commonItem)]: \(itemValue[commonItem, default: 0])")
                    result += itemValue[commonItem, default: 0]
                }
            }
            
            return result
        }
        
        func part02(_ elves: Input) -> Output {
            var result: Int = 0
            
            fillItemValues()
            
            for triplet in stride(from: 0, to: elves.count - 1, by: 3) {
                let elf0 = Set(elves[triplet + 0].l).union(Set(elves[triplet + 0].r))
                let elf1 = Set(elves[triplet + 1].l).union(Set(elves[triplet + 1].r))
                let elf2 = Set(elves[triplet + 2].l).union(Set(elves[triplet + 2].r))
                
                if let commonItem = elf0.intersection(elf1).intersection(elf2).first {
//                    print("[\(commonItem)]: \(itemValue[commonItem, default: 0])")
                    result += itemValue[commonItem, default: 0]
                }
            }
            
            return result
        }
        
        
        // MARK: - Helper Methods
        var itemValue: [Character: Int] = [:]
        
        func fillItemValues() {
            let a = UnicodeScalar("a").value
            let z = UnicodeScalar("z").value
            
            for i in a...z {
//                print("scalar \(i); value \(UnicodeScalar(i))")
                itemValue[Character(UnicodeScalar(i)!)] = Int(exactly: i)! - 96
            }
            
            let A = UnicodeScalar("A").value
            let Z = UnicodeScalar("Z").value
            
            for i in A...Z {
//                print("scalar \(i); value \(UnicodeScalar(i))")
                itemValue[Character(UnicodeScalar(i)!)] = Int(exactly: i)! - 38
            }

        }
    }
}

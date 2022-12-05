//
// 
//  AOC2022_Day05.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-05.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day05 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = (field: BoxField, instructions: [Instruction])
        typealias Output = String
        
        
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
            let inputComponents = rawInput.components(separatedBy: "\n\n")
//            print(inputComponents[0])
            
            let field = AdventOfCode2022.Day05.parseField(from: inputComponents[0])
            
            let instructions = inputComponents[1].components(separatedBy: .newlines)
                .compactMap { AdventOfCode2022.Day05.parseInstruction(from: $0) }
            
            let formattedOutput = rawOutput?.components(separatedBy: .newlines)[0]
            
            return ((field: field, instructions: instructions), formattedOutput)
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
            var result: String = ""
            
            var supplies = inputData.field
            
            // Last item is the topmost; first item is bottommost
            for instruction in inputData.instructions {
                for _ in 1...instruction.count {
//                    print("move \(instruction.count) from \(instruction.source) to \(instruction.target)")
                    supplies[instruction.target]!.append(supplies[instruction.source]!.removeLast())
                    
//                    print(supplies)
                }
            }
            
//            print(supplies)
            
            // Gather first letter from each array
            for index in supplies.keys.sorted(by: < ) {
                let box = supplies[index]!.removeLast()
                    .replacing(/\[(\w)\]/) { match in
                        return match.1
                    }
                
//                print(box)
                result.append(box)
            }
            
            return result
        }
        
        func part02(_ inputData: Input) -> Output {
            return ""
        }
        
        
        // MARK: - Helper Methods
        typealias BoxField = [Int: [String]]
        typealias Instruction = (count: Int, source: Int, target: Int)
        static let spacerBox: String = "[_]"
        
        static func parseField(from input: String) -> BoxField {
            var field: BoxField = BoxField()
            
            var lines = input.components(separatedBy: .newlines)
            
            let columns = lines.removeLast()
                .components(separatedBy: .whitespaces)
                .compactMap { Int($0) }
            
            let boxCollection = lines.compactMap { line in
                return line.replacing(/(^| )(\s{3})/) { match in
                    return "\(match.1)\(spacerBox)"
                }
                    .components(separatedBy: .whitespaces)
            }
            
            // Initialize columns in field
            for column in columns {
                field[Int(exactly: column)!] = []
            }
            
            for boxes in boxCollection {
                for (index, box) in boxes.enumerated() {
                    if box != spacerBox {
                        field[index + 1]!.append(box)
                    }
                }
            }
            
            // Reverse all arrays
            for column in field.keys {
                field[column] = field[column]!.reversed()
            }
                        
            return field
        }
        
        static func parseInstruction(from input: String?) -> Instruction? {
            guard let input = input else {
                return nil
            }
            
            let regex = /move (?<count>\d+) from (?<source>\d+) to (?<target>\d+)/
            
            if let result = input.firstMatch(of: regex) {
                let count: Int = Int(result.count)!
                let source: Int = Int(result.source)!
                let target: Int = Int(result.target)!
                
                return (count: count, source: source, target: target)
            }
            
            return nil
        }
    }
}

//
// 
//  AOC2022_Day10.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-10.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day10 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [Instruction]
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
                .compactMap { AdventOfCode2022.Day10.readInstruction($0) }
            
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
        func part01(_ instructions: Input) -> Output {
            var instructions = instructions
            
            let strength_measures: [Int] = Array(stride(from: 20, through: 220, by: 40))
            var queue: [Int] = [] // FIFO queue with Values to be added, offset by 2 (hence the zeros to begin with)
            var memory_x: Registry = (cycle: 1, value: 1) // Cycle number and value at end of associated cycle
            var strength: Int = 0
               
//            print(memory_x)

            repeat {
                // BEGIN CYCLE
//                print(list)
                
                // Read instruction and insert Value to queue
                if !instructions.isEmpty {
//                    print(instructions[0])
                    
                    switch instructions.removeFirst() {
                    case .noop: // noop takes one cycle to complete
                        queue.append(0)
                        
                    case let .addx(value): // addx takes two cycles to complete
                        queue.append(0)
                        queue.append(value)
                    }
                }
                
                // END CYCLE
                memory_x = (cycle: memory_x.cycle + 1, value: memory_x.value + queue.removeFirst())
                
                // Can we calculate strength for this cycle?
                if strength_measures.contains(memory_x.cycle) {
//                    print(memory_x)
                    
                    strength += memory_x.cycle * memory_x.value
                }
                
//                print(memory_x)
            } while (!instructions.isEmpty || !queue.isEmpty)
            
            return strength
        }
        
        func part02(_ inputData: Input) -> Output {
            return -99
        }
        
        
        // MARK: - Helper Methods
        enum Instruction {
            case noop
            case addx(Int)
        }
        
        typealias Registry = (cycle: Int, value: Int)
        
        static func readInstruction(_ line: String) -> Instruction? {
            let components = line.components(separatedBy: .whitespaces)
            
            switch components[0] {
            case "noop":
                return Instruction.noop
                
            case "addx":
                return Instruction.addx(Int(components[1])!)
                
            default:
                return nil
            }
        }
    }
}

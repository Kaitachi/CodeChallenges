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
        typealias Output = [String]
        
        
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
            
            let formattedOutput = rawOutput?.components(separatedBy: .newlines)
                .filter { !$0.isEmpty }
            
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
            let strength_measures: [Int] = Array(stride(from: 20, through: 220, by: 40))
            
            let strength: Int = AdventOfCode2022.Day10.execute(program: instructions)
                .filter { strength_measures.contains($0.cycle) } // Can we calculate strength for this cycle?
                .reduce(0) { $0 + ($1.cycle * $1.value)}
            
            return [String(strength)]
        }
        
        func part02(_ inputData: Input) -> Output {
            return [String(-99)]
        }
        
        
        // MARK: - Helper Methods
        enum Instruction {
            case noop
            case addx(Int)
        }
        
        typealias Register = (cycle: Int, value: Int)
        
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
        
        static func execute(program: [Instruction]) -> [Register] {
            var instructions = program
            var memory_history: [Register] = [Register]()
            var queue: [Int] = [] // FIFO queue with Values to be added, offset by 2 (hence the zeros to begin with)
            var memory: Register = (cycle: 1, value: 1) // Cycle number and value at end of associated cycle
               
//            print(memory)

            repeat {
                // BEGIN CYCLE
                
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
                memory = (cycle: memory.cycle + 1, value: memory.value + queue.removeFirst())
                memory_history.append(memory)
//                print(memory)
            } while (!instructions.isEmpty || !queue.isEmpty)
            
            return memory_history
        }
    }
}

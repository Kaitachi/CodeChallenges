//
// 
//  AOC2022_Day11.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-11.
//
//

import ChallengeBase
import Foundation

extension AdventOfCode2022 {
    class Day11 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [Monkey]
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
        func assemble(_ rawInput: String, _ rawOutput: String? = nil) -> (Input, Output?) {
            let formattedInput = rawInput.components(separatedBy: "\n\n")
                .enumerated()
                .compactMap { (index, text) in Monkey(index, description: text) }
                        
//            for monkey in formattedInput {
//                print(monkey)
//            }
            
            let formattedOutput = Int64(rawOutput?.components(separatedBy: .newlines)[0] ?? "")
                
            
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
        func part01(_ monkeys: Input) -> Output {
            let rounds: Int = 20
            let worry: (Int) -> Int = { item in item / 3 }
            
            return AdventOfCode2022.Day11.play(with: monkeys, for: rounds, worry: worry)
                .sorted { $0.inspections > $1.inspections }
                .enumerated()
                .filter { $0.offset < 2 }
                .compactMap { Int64($0.element.inspections) }
                .reduce(1, *)
        }
        
        func part02(_ monkeys: Input) -> Output {
            let rounds: Int = 1
            let worry: (Int) -> Int = { item in item / 3 }
            
            return AdventOfCode2022.Day11.play(with: monkeys, for: rounds, worry: worry)
                .sorted { $0.inspections > $1.inspections }
                .enumerated()
                .filter { $0.offset < 2 }
                .compactMap { Int64($0.element.inspections) }
                .reduce(1, *)
        }
        
        
        // MARK: - Helper Methods
        struct Monkey: CustomStringConvertible {
            var id: Int
            var items: [Int]
            var operation: String
            var testDivisor: Int
            var whenFalse: Int
            var whenTrue: Int
            var inspections: Int
            
            init(_ id: Int, description input: String) {
                let re_startingItems: Regex = /Starting items: (?<items>[\d,\s]*)\n/
                let re_operation: Regex = /Operation: new = (?<operation>[\w\W]*?)\n/
                let re_test: Regex = /Test: divisible by (?<divisor>[\d]*)/
                let re_ifTrue: Regex = /If true: throw to monkey (?<monkey>\d)/
                let re_ifFalse: Regex = /If false: throw to monkey (?<monkey>\d)/
                
//                print("input:\n\(input)")
                
                self.id = id
                self.inspections = 0
                
                if let result = input.firstMatch(of: re_startingItems) {
                    self.items = result.items.components(separatedBy: ", ")
                        .compactMap { Int($0) }
                } else {
                    print(">>> Could not find starting items!")
                    self.items = [Int]()
                }
                
                if let result = input.firstMatch(of: re_operation) {
                    self.operation = String(result.operation)
                } else {
                    print(">>> Could not find operation!")
                    self.operation = ""
                }
                
                if let result = input.firstMatch(of: re_test) {
                    self.testDivisor = Int(result.divisor)!
                } else {
                    print(">>> Could not find test!")
                    self.testDivisor = 0
                }

                if let result = input.firstMatch(of: re_ifTrue) {
                    self.whenTrue = Int(result.monkey)!
                } else {
                    print(">>> Could not find true!")
                    self.whenTrue = -1
                }
                
                if let result = input.firstMatch(of: re_ifFalse) {
                    self.whenFalse = Int(result.monkey)!
                } else {
                    print(">>> Could not find false!")
                    self.whenFalse = -1
                }

//                print()
            }
            
            mutating func inspect(_ worry: (Int) -> Int) -> (item: Int, giveTo: Int) {
//                print("Monkey \(id) is inspecting!")
                
                let item: [String: Int] = ["old": self.items.removeFirst()]
                let new: Int = self.operation.evaluate(with: item) as! Int
                let isDivisible: Bool = ((worry(new) % self.testDivisor) == 0)
                let giveTo: Int = isDivisible ? self.whenTrue : self.whenFalse
                
                print("Handling item \(item)...")
                print("New item value \(new)")
                print("\(worry(new)) divisible by \(self.testDivisor)? \(isDivisible)")
                print()

                self.inspections += 1
                return (item: worry(new), giveTo: giveTo)
            }
            
            mutating func receive(_ item: Int) {
                self.items.append(item)
            }
            
            var description: String {
                return "Monkey \(self.id): \(self.items)"
            }
        }
        
        static func play(with monkeys: Input, for rounds: Int, worry: (Int) -> Int) -> Input {
            var monkeys = monkeys
            
            for round in 1...rounds {
                for index in 0..<monkeys.count {
                    while (!monkeys[index].items.isEmpty) {
                        let item = monkeys[index].inspect(worry)
                        monkeys[item.giveTo].receive(item.item)
                    }
                }
                
                if [1, 20, rounds].contains(round) {
                    print("=== ROUND \(round) ===")
                    for monkey in monkeys {
                        print("Monkey \(monkey.id) inspected \(monkey.inspections) times.")
                    }
                    print()
                }
            }

            return monkeys
        }
    }
}

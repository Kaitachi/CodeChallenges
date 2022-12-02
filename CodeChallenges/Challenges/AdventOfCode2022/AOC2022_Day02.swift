//
// 
//  AOC2022_Day02.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-02.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day02 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [(opp: String, me: String)]
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
                .compactMap {
                    let line = $0.components(separatedBy: .whitespaces)
                    
                    if line.count == 2 {
                        return (opp: line[0], me: line[1])
                    }
                    
                    return nil
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
            var totalScore: Int = 0
            
            for round in inputData {
                totalScore += AdventOfCode2022.Day02.playRound(round.opp, round.me)
            }
            
            return totalScore
        }
        
        func part02(_ inputData: Input) -> Output {
            var totalScore: Int = 0
            
            for round in inputData {
                totalScore += AdventOfCode2022.Day02.figureRound(round.opp, round.me)
            }
            
            return totalScore
        }
        
        
        // MARK: - Helper Methods
        enum round: Int {
            case lost = 0
            case draw = 3
            case win = 6
        }
        
        enum tool: Int {
            case rock = 1
            case paper = 2
            case scissors = 3
        }

        static let opponentTools: [String: tool] = [
            "A": .rock,
            "B": .paper,
            "C": .scissors
        ]
        
        static let myTools: [String: tool] = [
            "X": .rock,
            "Y": .paper,
            "Z": .scissors
        ]
        
        static let myOutcomes: [String: round] = [
            "X": .lost,
            "Y": .draw,
            "Z": .win
        ]
        
        struct playedTools: Hashable {
            var opp: tool
            var me: tool
        }
        
        static let resolve: [playedTools: round] = [
            playedTools(opp: .rock, me: .rock):         .draw,
            playedTools(opp: .rock, me: .paper):        .win,
            playedTools(opp: .rock, me: .scissors):     .lost,
            playedTools(opp: .paper, me: .rock):        .lost,
            playedTools(opp: .paper, me: .paper):       .draw,
            playedTools(opp: .paper, me: .scissors):    .win,
            playedTools(opp: .scissors, me: .rock):     .win,
            playedTools(opp: .scissors, me: .paper):    .lost,
            playedTools(opp: .scissors, me: .scissors): .draw
        ]
        
        static func playRound(_ opp: String, _ me: String) -> Int {
            let oppTool = opponentTools[opp]!
            let myTool = myTools[me]!
            
            // determine who won
            let roundOutcome = resolve[playedTools(opp: oppTool, me: myTool)]!

            return roundOutcome.rawValue + myTool.rawValue
        }
        
        static func figureRound(_ opp: String, _ outcome: String) -> Int {
            let oppTool = opponentTools[opp]!
            let roundOutcome = myOutcomes[outcome]!
            
            // determine my tool
            let myTool = resolve
                .filter { $0.value == roundOutcome }
                .filter { $0.key.opp == oppTool }
                .first!
                .key.me
            
            return roundOutcome.rawValue + myTool.rawValue
        }
    }
}

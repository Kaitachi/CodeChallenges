//
// 
//  Day04.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-25.
//
//

import ChallengeBase

extension AdventOfCode2021 {
    class Day04 : AdventOfCode2021, Solution {
        // MARK: - Type Aliases
        typealias Input = (calls: [Int], boards: [Grid2D])
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
        func assemble(_ input: String, _ output: String? = nil) -> (Input, Output?) {
            var calls: [Int]? = nil
            var boards: [Grid2D] = [Grid2D]()
                        
            for section in input.components(separatedBy: "\n\n") {
                if calls == nil {
                    calls = section.integerList(separatedBy: .punctuationCharacters)
                } else {
                    boards.append(section.integerArray2D())
                }
            }
            
            let finalScore = output?.integerList()[0]
            
            return ((calls: calls!, boards: boards), finalScore)
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
        func part01(_ bingo: Input) -> Output {
            return AdventOfCode2021.Day04.startGame(bingo, winning: 1)
        }
        
        func part02(_ bingo: Input) -> Output {
            return AdventOfCode2021.Day04.startGame(bingo)
        }
        
        
        // MARK: - Helper Methods
        static func startGame(_ bingo: Input, winning place: Int? = nil) -> Int {
            var game: [Grid2D] = bingo.boards
            var winningCall: Int = Int()
            var winningBoard: Grid2D = Grid2D()
            var winningBoards: Set<Int> = Set<Int>()
            var winningPlace: Int = place ?? game.count
                        
            // Identify winning board and call number
            foundBoard: for call in bingo.calls {
                for board in 0 ..< game.count {
                    if let match = AdventOfCode2021.Day04.call(number: call, in: game[board]) {
                        // Remove cell contents
                        game[board][match.y][match.x] = nil
                        
                        // It would make sense that the only time a board is candidate to win
                        // is when it has found a match...right?
                        if AdventOfCode2021.Day04.verify(game[board]) && !winningBoards.contains(board) {
                            winningCall = call
                            winningBoard = game[board]
                            winningBoards.insert(board)
                            winningPlace -= 1
                                                        
                            if winningPlace <= 0 {
                                break foundBoard
                            }
                        }
                    }
                }
            }
                        
            // Calculate sum of all unmarked numbers
            let remainingSum = Array(winningBoard.joined())
                .compactMap { $0 }
                .reduce(0, +)
            
            return remainingSum * winningCall
        }
        
        static func call(number call: Int, in board: Grid2D) -> Coordinate? {
            let dimensions: Coordinate = (x: board.count, y: board[0].count)
            
            if let index = Array(board.joined()).firstIndex(of: call) {
                return (x: index % dimensions.x, y: index / dimensions.y)
            }
                        
            return nil
        }
        
        static func verify(_ board: Grid2D) -> Bool {
            let tests: [Set<Int>] = [
                Set([0, 1, 2, 3, 4]),
                Set([5, 6, 7, 8, 9]),
                Set([10, 11, 12, 13, 14]),
                Set([15, 16, 17, 18, 19]),
                Set([20, 21, 22, 23, 24]),
                Set([0, 5, 10, 15, 20]),
                Set([1, 6, 11, 16, 21]),
                Set([2, 7, 12, 17, 22]),
                Set([3, 8, 13, 18, 23]),
                Set([4, 9, 14, 19, 24]),
            ]
            
            // One row has no numbers
            var matches = Array(board.joined())
                .enumerated()
                .filter { $0.element == nil }
                .map { $0.offset }
                            
            for test in tests {
                if test.subtracting(matches).count == 0 {
                    return true
                }
            }
            
            return false
        }
    }
}
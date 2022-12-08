//
// 
//  AOC2022_Day08.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-08.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day08 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [[Int]]
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
                .filter { !$0.isEmpty }
                .compactMap { line in
                    return Array(line)
                        .compactMap { Int(String($0)) }
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
            let overgrowths = AdventOfCode2022.Day08.showTreeOvergrowth(for: inputData)
            let totalTrees = inputData.count * inputData[0].count
            
            let exposedTrees = overgrowths.map { row in
                row.map { tree in
                    return (tree <= 0) ? 0 : 1
                }
                .reduce(0, +)
            }
            .reduce(0, +)
                        
            return exposedTrees
        }
        
        func part02(_ inputData: Input) -> Output {
            return -1
        }
        
        
        // MARK: - Helper Methods
        static func showTreeOvergrowth(for grid: Input) -> [[Int]] {
            var overgrowths: [[Int]] = grid
            
            let gridRows = grid
            let gridCols = grid.enumerated().map { (index, _) in
                return grid.map { $0[index] }
            }
            
//            for (index, row) in gridRows.enumerated() {
//                print("gridRow[\(index)]: \(row)")
//            }
//            
//            for (index, col) in gridCols.enumerated() {
//                print("gridCol[\(index)]: \(col)")
//            }
            
            for (row, rowElement) in overgrowths.enumerated() {
                for (col, colElement) in rowElement.enumerated() {
                    let N = gridCols[col][0..<row]
                    let S = gridCols[col][(row + 1)..<(gridCols.count)]
                    let W = gridRows[row][0..<col]
                    let E = gridRows[row][(col + 1)..<(gridRows.count)]
                    
//                    print("element: \(colElement)")
//                    print("grid[\(row)][\(col)] -> N: \(N); S: \(S); W: \(W); E: \(E)")
                    
                    // Do not ask about -1...
                    let viewN = colElement - (N.sorted(by: < ).last ?? -1)
                    let viewS = colElement - (S.sorted(by: < ).last ?? -1)
                    let viewW = colElement - (W.sorted(by: < ).last ?? -1)
                    let viewE = colElement - (E.sorted(by: < ).last ?? -1)
                    let orthogonalViews = [viewN, viewS, viewW, viewE]
                    
                    overgrowths[row][col] = orthogonalViews.sorted(by: < ).last!

//                    print("> views of [\(colElement)] -> N: \(viewN); S: \(viewS); W: \(viewW); E: \(viewE)")
//                    print("> exposed amount for [\(colElement)]: \(overgrowths[row][col])")
                    
//                    print()
                }
            }
            
//            print()
//            print()
//
//            for row in grid {
//                print(row)
//            }
//
//            print()
//            print()
//
//            for row in overgrowths {
//                print(row)
//            }
            
            return overgrowths
        }
    }
}

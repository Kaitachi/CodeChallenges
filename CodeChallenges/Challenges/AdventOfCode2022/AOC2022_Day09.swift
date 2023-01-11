//
// 
//  AOC2022_Day09.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2023-01-09.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day09 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [Direction]
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
                .compactMap { $0.cardinalDirection(directions: AdventOfCode2022.Day09.ROPE_MOVEMENTS) }
            
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
            let HEAD: Cell2DIndex = Cell2DIndex(row: 0, col: 0)
            let TAIL: Cell2DIndex = Cell2DIndex(row: 0, col: 0)
            
            var grid: RopeCanvas = RopeCanvas(head: HEAD, tail: TAIL)
            
//            grid.debug()
            
            for instruction in inputData {
//                print("=== INSTRUCTION ===")
//                print("instruction: \(instruction)")

                for step in AdventOfCode2022.Day09.steps(in: instruction) {
//                    print("=== STEPS ===")
//                    print("step: \(step)")
                    grid.moveRope(headOffset: step)
                }
                
//                grid.debug()
//                print()
            }
            
            return grid.visits.filter { $0.item == Rope.T.rawValue }.count
        }
        
        func part02(_ inputData: Input) -> Output {
            return -1
        }
        
        
        // MARK: - Helper Methods
        enum Rope: Int, CustomStringConvertible {
            case T = -1 // Tail
            case Z =  0 // Empty
            case H =  1 // Head
            case X =  2 // Overlap
            case S = -9 // Source
            
            var description: String {
                get {
                    switch self {
                    case .T: return "T"
                    case .Z: return "."
                    case .H: return "H"
                    case .X: return "X"
                    case .S: return "s"
                    }
                }
            }
        }
        
        static let ROPE_MOVEMENTS: [String: CardinalDirection] = [
            "U": .N,
            "R": .E,
            "D": .S,
            "L": .W
        ]
        
        static func steps(in direction: Direction) -> [Cell2DIndex] {
            var vector: Cell2DIndex
            var steps: Int
            
            switch direction {
            case .North(let amount):
                vector = (row: 1, col: 0)
                steps = amount
                break
                
            case .South(let amount):
                vector = (row: -1, col: 0)
                steps = amount
                break
                
            case .West(let amount):
                vector = (row: 0, col: -1)
                steps = amount
                break
                
            case .East(let amount):
                vector = (row: 0, col: 1)
                steps = amount
                break
                
            default:
                vector = (row: 0, col: 0)
                steps = 0
                break
            }
            
            return stride(from: 1, through: steps, by: 1)
                .map { _ in vector }
        }
        
        
        struct RopeCanvas {
            var canvas: Grid2D<Int>
            var visits: Set<Cell2D<Int>> = Set<Cell2D<Int>>()
            
            init(head: Cell2DIndex, tail: Cell2DIndex) {
                self.canvas = Grid2D<Int>(with: [
                    (matrix: Kernels.horizontal, type: .primary),
                    (matrix: Kernels.vertical, type: .primary),
                    (matrix: Kernels.dpad, type: .secondary)
                ])
                
                self.canvas.items.formUnion([
                    Cell2D<Int>(at: head, item: Rope.H.rawValue),
                    Cell2D<Int>(at: tail, item: Rope.T.rawValue)
                ])
            }
            
            // Computed Properties
            var HEAD: Cell2D<Int> {
                get {
                    return self.canvas.items
                        .filter { $0.item == Rope.H.rawValue }
                        .first!
                }
            }
            
            var TAIL: Cell2D<Int> {
                get {
                    return self.canvas.items
                        .filter { $0.item == Rope.T.rawValue }
                        .first!
                }
            }
            
            var bestCandidate: Cell2D<Int>? {
                let primaryPositions: [Cell2D<Int>] = getCandidates(of: .primary)
                
                switch primaryPositions.count {
                case 1: // Exactly one distinct candidate location to move to exists, select it
                    return primaryPositions.first!
                    
                case 2: // More than one candidate exists, let's use auxiliary kernels to determine where to move to next
                    let secondaryPositions: [Cell2D<Int>] = getCandidates(of: .secondary)
                    
                    return (primaryPositions + secondaryPositions)
                        .sortedByFrequency()
                        .reversed()
                        .first!
                    
                default: // No candidates exist, return nil
                    return nil
                }
            }
            
            mutating func moveRope(headOffset: Cell2DIndex, tailOffset: Cell2DIndex? = nil) {
                _ = moveHead(by: headOffset)
                _ = moveTail()
                
                // Add current positions to visit collection
                self.visits.insert(self.HEAD)
                self.visits.insert(self.TAIL)
            }
            
            mutating func moveHead(by offset: Cell2DIndex) -> Cell2D<Int> {
                guard offset != (row: 0, col: 0) else {
                    return self.HEAD
                }
                
                let target: Cell2DIndex = (row: self.HEAD.row + offset.row, col: self.HEAD.col + offset.col)
                
                self.canvas.items.remove(self.HEAD)
                self.canvas.items.insert(Cell2D<Int>(at: target, item: Rope.H.rawValue))
                
                return self.HEAD
            }
            
            mutating func moveTail() -> Cell2D<Int>? {
                guard let target = self.bestCandidate else {
                    return nil
                }
                
                let newPos: Cell2DIndex = getTailRelativeCoordinate(from: target.index)
                
                self.canvas.items.remove(self.TAIL)
                self.canvas.items.insert(Cell2D<Int>(at: newPos, item: Rope.T.rawValue))
                
                return target
            }
            
            func getTailRelativeCoordinate(from cell: Cell2DIndex) -> Cell2DIndex {
                let row = self.TAIL.row + cell.row - 1
                let col = self.TAIL.col + cell.col - 1
                
                return (row: row, col: col)
            }
                        
            func getCandidates(of type: Grid2D<Int>.KernelType) -> [Cell2D<Int>] {
                return self.canvas.convolved(around: self.TAIL.index, of: type)
                    .filter { 2 < abs($0.item ?? 0) } // Only strong positions are considered
                    .filter { type != .secondary || 2 < ($0.item ?? 0) } // Secondary-type kernels should be as close as possible to head
            }
            
            func debug() {
                print("HEAD: \(self.HEAD.index)")
                print("TAIL: \(self.TAIL.index)")
                
                self.canvas.described(from: (row: 0, col: 0), to: (row: 10, col: 10), textProvider: self.printCell)
            }
            
            func printCell(index: Cell2DIndex, items: [Cell2D<Int>]) -> String {
                let value = items
                    .sorted { $1.item! < $0.item! }
                    .first?.item ?? Rope.Z.rawValue
                
                var element = Rope.init(rawValue: value) ?? Rope.Z
                
                if element == Rope.Z && index == (row: 0, col: 0) {
                    element = Rope.S
                }
                
                return element.description
            }
        }
    }
}

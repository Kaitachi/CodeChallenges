//
// 
//  AOC2022_Day14.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2023-01-09.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day14 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [Cell2D<Int>]
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
            let rocks = rawInput.components(separatedBy: .newlines)
                .compactMap { Rock.generateRock(from: $0) }
                .flatMap { $0 }
            
            let formattedOutput = rawOutput?.integerList()[0]
            
            return (rocks, formattedOutput)
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
            let SOURCE: Cell2DIndex = (row: 0, col: 500)
            
            var grid: SandCanvas = SandCanvas(source: SOURCE)
            
            grid.add(rocks: inputData)

            let TOP_LEFT: Cell2DIndex = (row: 0, col: 470)
            let BOTTOM_RIGHT: Cell2DIndex = (row: grid.groundLevel, col: 535)

            grid.debug(from: TOP_LEFT, to: BOTTOM_RIGHT)

            var offender: Cell2D<Int>? = nil

            repeat {
                grid.addGrain()
                offender = grid.moveGrains()
                
//                grid.debug(from: TOP_LEFT, to: BOTTOM_RIGHT)
            } while (offender == nil)

            grid.debug(from: TOP_LEFT, to: BOTTOM_RIGHT)
            print("FINISHED")
            print("grains in grid: \(grid.grains.count)")
            
            return grid.grains.count
        }
        
        func part02(_ inputData: Input) -> Output {
            let SOURCE: Cell2DIndex = (row: 0, col: 500)
            
            var grid: SandCanvas = SandCanvas(source: SOURCE, hasGround: true)
            
            grid.add(rocks: inputData)

            let TOP_LEFT: Cell2DIndex = (row: 0, col: 470)
            let BOTTOM_RIGHT: Cell2DIndex = (row: grid.groundLevel, col: 535)

            grid.debug(from: TOP_LEFT, to: BOTTOM_RIGHT)

            var offender: Cell2D<Int>? = nil

            repeat {
                grid.addGrain()
                offender = grid.moveGrains()
                grid.createAirPockets()
                
                print("grain count: \(grid.grains.count + grid.sandpit.items.count)")
//                grid.debug(from: TOP_LEFT, to: BOTTOM_RIGHT)
            } while (offender == nil)

            grid.debug(from: TOP_LEFT, to: BOTTOM_RIGHT)
            print("FINISHED")
            print("grains in grid: \(grid.grains.count)")
            
            return grid.grains.count + grid.sandpit.items.count
        }
        
        
        // MARK: - Helper Methods
        enum Sandbox: Int, CustomStringConvertible {
            case S =   100 // Source
            case Z =     0 // Empty
            case I =     1 // Falling Sand
            case O =   -99 // Settled Sand
            case R =  -100 // Rock
            case G =  -200 // Ground
            
            public var description: String {
                get {
                    switch self {
                    case .S: return "+"
                    case .R: return "#"
                    case .Z: return "."
                    case .I: return "*"
                    case .O: return "o"
                    case .G: return "="
                    }
                }
            }
        }
        
        struct Rock {
            static func generateRock(from path: String) -> [Cell2D<Int>]? {
                guard !path.isEmpty else {
                    return nil
                }
                
                let edges = path.components(separatedBy: " -> ")
                    .map { coordinate in
                        let components = coordinate.components(separatedBy: ",")
                        
                        return Cell2DIndex(row: Int(components[1])!, col: Int(components[0])!)
                    }
                
                var points: [Cell2D<Int>] = [Cell2D<Int>]()
                
                for i in 0..<edges.count-1 {
                    let from: Cell2DIndex = edges[i]
                    let to: Cell2DIndex = edges[i+1]
                    
                    let drow: Int = to.row - from.row
                    let dcol: Int = to.col - from.col
                    
                    if dcol != 0 {
                        stride(from: from.col, through: to.col, by: dcol / abs(dcol))
                            .forEach {
                                points.append(Cell2D<Int>(row: from.row, col: $0, item: Sandbox.R.rawValue))
                            }
                    } else if drow != 0 {
                        stride(from: from.row, through: to.row, by: drow / abs(drow))
                            .forEach {
                                points.append(Cell2D<Int>(row: $0, col: from.col, item: Sandbox.R.rawValue))
                            }
                    } else {
                        print("no movement?")
                    }
                }
                
                return points
            }
        }
        
        struct SandCanvas {
            // Input variables
            var hasGround: Bool
            
            var canvas: Grid2D<Int>
            var sandpit: Grid2D<Int>
            
            init(source: Cell2DIndex, hasGround: Bool = false) {
                self.hasGround = hasGround
                
                self.canvas = Grid2D<Int>()
                self.sandpit = Grid2D<Int>()
                self.canvas.items.insert(Cell2D<Int>(at: source, item: Sandbox.S.rawValue))
            }
            
            // Computed Properties
            var SOURCE: Cell2D<Int> {
                get {
                    return self.canvas.items
                        .filter { $0.item == Sandbox.S.rawValue }
                        .first!
                }
            }
            
            var grains: Set<Cell2D<Int>> {
                get {
                    return self.canvas.items
                        .filter { $0.item == Sandbox.O.rawValue }
                }
            }
            
            var lowestRock: Cell2D<Int> {
                get {
                    return self.canvas.items
                        .filter { $0.item == Sandbox.R.rawValue }
                        .sorted { $1.row < $0.row }
                        .first!
                }
            }
            
            var groundLevel: Int {
                get {
                    return self.lowestRock.row + 2
                }
            }
            
            mutating func addGrain() {
                self.canvas.items.insert(Cell2D<Int>(at: SOURCE.index, item: Sandbox.I.rawValue))
            }
            
            mutating func moveGrains() -> Cell2D<Int>? {
                repeat {
                    let movingGrains = self.canvas.items.filter { $0.item == Sandbox.I.rawValue }
                
                    for grain in movingGrains {
                        //print("moving grain \(grain)")
                        var grainArea = Grid2D<Int>(with: [
                            (matrix: Kernels.gravity, type: .primary)
                        ])
                        
                        let region = Array(self.canvas.items
                                            .filter { ($0.row == grain.row + 1) && abs($0.col - grain.col) <= 1 || $0.item == Sandbox.I.rawValue })
                        
                        grainArea.items.formUnion(region)
                        
                        if self.hasGround && grain.index.row == self.groundLevel - 1 {
                            let ground = stride(from: grain.col - 1, through: grain.col + 1, by: 1)
                                .map { Cell2D(row: self.groundLevel, col: $0, item: Sandbox.G.rawValue) }
                            
                            grainArea.items.formUnion(ground)
                        }
                        
                        let candidates = grainArea.convolved(around: grain.index)
                            .filter { 0 < ($0.item ?? 0) }
                            .sorted { $1.item! < $0.item! }
                                                            
                        self.canvas.items.remove(grain)
                    
                        guard let target = candidates.first else {
                            //print("No target candidates found!")
                            
                            // Settle this grain of sand
                            self.canvas.items.insert(Cell2D(at: grain.index, item: Sandbox.O.rawValue))
                            return nil
                        }
                    
                        // Move this grain of sand
                        let newLocation = getRelativeCoordinate(for: grain, from: target.index)
                        
                        guard newLocation != grain.index else {
                            //print("nowhere good to go...")
                            
                            // Best position is where we already are
                            let settledGrain = Cell2D<Int>(at: grain.index, item: Sandbox.O.rawValue)
                            self.canvas.items.insert(settledGrain)
                            
                            return (newLocation == self.SOURCE.index) ? settledGrain : nil
                        }
                        
                        //print("found target \(target)")
                        //print("moving grain to \(newLocation)")
                    
                        self.canvas.items.insert(Cell2D<Int>(at: newLocation, item: Sandbox.I.rawValue))
                    }
                } while (self.canvas.items
                    .filter { // Stop loop whenever...
                        ($0.item == Sandbox.I.rawValue && $0.row <= self.groundLevel) // ...grain of sand is below the ground...
                        || ($0.item == Sandbox.O.rawValue && $0.index == SOURCE.index) // ...or when our source is filled up
                    }.count > 0)
                
                return self.canvas.items.filter {
                    ($0.item == Sandbox.I.rawValue)
                    || ($0.index == SOURCE.index && $0.item != Sandbox.S.rawValue)
                }.first!
            }
            
            mutating func createAirPockets() {
                var fullSandbox: Grid2D<Int> = Grid2D<Int>()
                var buriedGrains: [Cell2D<Int>] = [Cell2D<Int>]()
                
                fullSandbox.items.formUnion(self.canvas.items)
                fullSandbox.items.formUnion(self.sandpit.items)
                
                fullSandbox.items
                    .filter { $0.item == Sandbox.O.rawValue }
                    .forEach { grain in
                        var grainArea: Grid2D<Int> = Grid2D<Int>()
                        
                        grainArea.items.formUnion(fullSandbox.items
                            .filter { abs($0.row - grain.row) <= 1 && abs($0.col - grain.col) <= 1 })
                        
                        let result = grainArea.convolve(single: Kernels.buried, at: grain.index)
                            //.filter { $0.item == Sandbox.O.rawValue }
                        
                        if result == 5 * Sandbox.O.rawValue {
                            buriedGrains.append(grain)
                        }
                    }
                
                self.canvas.items.subtract(buriedGrains)
                self.sandpit.items.formUnion(buriedGrains)
            }
            
            func getRelativeCoordinate(for grain: Cell2D<Int>, from cell: Cell2DIndex) -> Cell2DIndex {
                let row = grain.row + cell.row - 1
                let col = grain.col + cell.col - 1
                    
                return Cell2DIndex(row: row, col: col)
            }
            
            mutating func add(rocks newRocks: [Cell2D<Int>]) {
                self.canvas.items.formUnion(newRocks)
            }
            
            func debug(from: Cell2DIndex, to: Cell2DIndex) {
                print("=== SANDBOX ===")
                
                self.canvas.described(from: from, to: to, showIndices: true, textProvider: self.printCell)
            }
            
            func printCell(index: Cell2DIndex, items: [Cell2D<Int>]) -> String {
                let value = items.sorted { $1.item! < $0.item! }.first?.item ?? Sandbox.Z.rawValue
                
                var element = Sandbox.init(rawValue: value) ?? Sandbox.Z
                
                if element == Sandbox.Z && index.row == self.groundLevel {
                    element = Sandbox.G
                }
                
                return element.description
            }
        }
    }
}

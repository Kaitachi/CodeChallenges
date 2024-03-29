//
//  Grid.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2023-01-09.
//

protocol GridCell2D {
    var row: Int { get set }
    var col: Int { get set }
}



// MARK: - Cell2DItem
struct Cell2D<T: Equatable & Hashable>: GridCell2D & Equatable & Hashable {
    var row: Int
    var col: Int
    var item: T?
    
    init(row: Int, col: Int, item: T? = nil) {
        self.row = row
        self.col = col
        self.item = item
    }
    
    init(at location: Cell2DIndex, item: T) {
        self.row = location.row
        self.col = location.col
        self.item = item
    }
    
    var index: Cell2DIndex {
        get {
            return (row: self.row, col: self.col)
        }
        set {
            self.row = newValue.row
            self.col = newValue.col
        }
    }
}


// MARK: - Grid2D
public struct Grid2D<T: Hashable & Equatable> {
    enum KernelType {
        case primary
        case secondary
    }
    
    var items: Set<Cell2D<T>>
    var kernels: [(matrix: Matrix2D, type: KernelType)]
    
    init(with kernels: [(matrix: Matrix2D, type: KernelType)]? = nil) {
        self.items = Set<Cell2D<T>>()
        self.kernels = kernels ?? [(matrix: Matrix2D, type: KernelType)]()
    }
    
    func convolve(single kernel: Matrix2D, at point: Cell2DIndex, defaultValue: Int = 0) -> Int {
        var result: Int = 0

        for k_row in 0..<kernel.count {
            for k_col in 0..<kernel[0].count {
                // print("kernel[\(k_row)][\(k_col)]: \(kernel[k_row][k_col])")
                
                let row: Int = point.row + k_row - 1
                let col: Int = point.col + k_col - 1
                
                // var mtx: Int? = self.items.getElement(at: (row: row, col: col))
                
                // print("matrix[\(col)][\(row)]: \(mtx)")
                
                result += (self.items.getElement(at: (row: row, col: col)) ?? defaultValue) * kernel[k_row][k_col]
            }
        }
        // print("result: \(result)")
        
        return result
    }
    
    func convolved(around center: Cell2DIndex, of type: KernelType? = nil) -> [Cell2D<Int>] {
        var results = [Cell2D<Int>]()
        
        self.kernels
            .filter { type == nil || $0.type == type }
            .forEach { kernel in
            var projection = Kernels.zeros
            
            // search tiles around given point
            for row in 0..<projection.count {
                for col in 0..<projection[0].count {
                    let coord: Cell2DIndex = (row: center.row + row - 1, col: center.col + col - 1)
                    
                    projection[row][col] = self.convolve(single: kernel.matrix, at: coord)
                }
            }
            
            projection.enumerated().forEach { i, row in
                row.enumerated().forEach { j, cell in
                    results.append(Cell2D<Int>(at: (row: i, col: j), item: cell))
                }
            }
        }
        
        return results
    }
    
    func described(from: Cell2DIndex, to: Cell2DIndex, showIndices: Bool = false, textProvider text: (Cell2DIndex, [Cell2D<T>]) -> String) {
        let largestRowNum: Int = [from.row.length, to.row.length].max()! + 1
        
        if showIndices {
            let leftPad: Int = largestRowNum + 2
            let largestColNum: Int = [from.col.length, to.col.length].max()!
            
            stride(from: from.col, through: to.col, by: 1)
                .map { $0 % 5 == 0
                    ? Array(String(format: "%\(largestColNum)d", $0))
                    : Array(String(repeating: " ", count: largestColNum))
                }
                .transposed()
                .forEach { line in
                    print(String(repeating: " ", count: leftPad), terminator: "")
                    print(String(line))
                }
        }
        
        stride(from: from.row, through: to.row, by: 1)
            .forEach { row in
                if showIndices {
                    print(String(format: "%\(largestRowNum)d  ", row), terminator: "")
                }
                
                stride(from: from.col, through: to.col, by: 1)
                    .forEach { col in
                        let index: Cell2DIndex = (row: row, col: col)
                        let items: [Cell2D<T>] = self.items.filter { $0.index == index }
                                            
                        print(text((row: row, col: col), Array(items)), terminator: "")
                    }
                
                print()
            }

        print()
    }
}

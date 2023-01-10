//
//  Array2D+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-12.
//

import Foundation

// MARK: - Type Aliases
typealias Matrix2D = [[Int]]
typealias Cell2DIndex = (row: Int, col: Int)
typealias KernelMapping<T: Hashable, U: Hashable> = (matrix: Cell2D<T>, kernel: Cell2D<U>)


// MARK: - Array2D Extension
// This might be the weirdest extension youve ever seen...
extension Array where Element: Collection & CustomStringConvertible,
                      Element.Index == Int,
                      Element.Element: Equatable & Hashable {
    
    var size: Int {
        return self.count * self[0].count
    }
    
    var described: String {
        return String(self.map { $0.description }.joined(separator: "\n"))
    }
    
    func index(of value: Element.Element) -> Cell2DIndex? {
        self.indices(of: value).first
    }
    
    func indices(of value: Element.Element) -> [Cell2DIndex] {
        self.map { row in
            row.enumerated()
                .filter { $0.element == value }
                .map { $0.offset }
        }
        .enumerated()
        .compactMap { row in
            var indices: [Cell2DIndex] = [Cell2DIndex]()
                        
            for element in row.element {
                indices.append(Cell2DIndex(row: row.offset, col: element))
            }
            
            return indices
        }
        .reduce([], +)
    }
    
    // Overlap given kernel over certain section of our matrix
    // and perform some operation on all cells that overlap
    // kernel: M x N matrix to be overlapped over our matrix
    // point: Cell to overlap kernel's (row: 0, col: 0) cell with
    func convolve<KElement, KResult>(with kernel: [[KElement]],
                                     at point: Cell2DIndex = (row: 0, col: 0),
                                     using operate: ([KernelMapping<Element.Element, KElement>]) -> KResult) -> KResult {
        var pairs: [KernelMapping<Element.Element, KElement>] = [KernelMapping<Element.Element, KElement>]()
        
        for (i, k_row) in kernel.enumerated() {
            for (j, k_cell) in k_row.enumerated() {
                let row: Int = point.row + i - 1
                let col: Int = point.col + j - 1
                
                guard (0..<self.count).contains(row),
                      (0..<self[row].count).contains(col) else {
//                    print("Out of bounds: (\(row), \(col))")
                    continue
                }
                
//                print("convolving at (\(row), \(col))")
                pairs.append((
                    matrix: Cell2D(row: row, col: col, item: self[row][col]),
                    kernel: Cell2D(row: i, col: j, item: k_cell)
                ))
            }
        }
        
        return operate(pairs)
    }
}


// MARK: - Convolution Algorithms
struct Convolutions {
    static let standard: ([KernelMapping<Int, Int>]) -> Int = { pairs in
        pairs.map { ($0.matrix.item ?? 0) * ($0.kernel.item ?? 0) }.reduce(0, +)
    }
}


// MARK: - Convolution Kernels
struct Kernels {
    static var zeros: Matrix2D {
        [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
        ]
    }
    
    static var center: Matrix2D {
        [
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0]
        ]
    }
    
    static var standard: Matrix2D {
        [
            [1, 1, 1],
            [1, 0, 1],
            [1, 1, 1]
        ]
    }
    
    static var taxicab: Matrix2D {
        [
            [0, 1, 0],
            [1, 0, 1],
            [0, 1, 0]
        ]
    }
    
    static var horizontal: Matrix2D {
        [
            [-1, 0, 1],
            [-2, 0, 2],
            [-1, 0, 1]
        ]
    }
    
    static var vertical: Matrix2D {
        [
            [1, 2, 1],
            [0, 0, 0],
            [-1, -2, -1]
        ]
    }
    
    static var dpad: Matrix2D {
        [
            [0, 3, 0],
            [3, 0, 3],
            [0, 3, 0]
        ]
    }
    
    static var gravity: Matrix2D {
        [
            [10, 20, 15],
            [0, 5, 0],
            [0, 0, 0]
        ]
    }
}

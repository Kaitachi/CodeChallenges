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
            row.firstIndex(of: value)
        }
        .enumerated()
        .compactMap { row in
            guard let element = row.element else {
                return nil
            }
            
            return (row: row.offset, col: element)
        }
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
                    matrix: Cell2D(row: row, col: col, value: self[row][col]),
                    kernel: Cell2D(row: i, col: j, value: k_cell)
                ))
            }
        }
        
        return operate(pairs)
    }
}


struct Cell2D<T: Hashable>: Equatable & Hashable {
    var row: Int
    var col: Int
    var value: T?
    
    public init(row: Int, col: Int, value: T? = nil) {
        self.row = row
        self.col = col
        self.value = value
    }
}


// MARK: - Convolution Algorithms
struct Convolutions {
    static let standard: ([KernelMapping<Int, Int>]) -> Int = { pairs in
        pairs.map { ($0.matrix.value ?? 0) * ($0.kernel.value ?? 0) }.reduce(0, +)
    }
}


// MARK: - Convolution Kernels
struct Kernels {
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
}

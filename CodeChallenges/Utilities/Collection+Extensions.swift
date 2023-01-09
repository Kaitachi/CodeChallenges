//
//  Collection+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2023-01-09.
//

import Foundation

extension Collection where Self.Iterator.Element: RandomAccessCollection {
    // Kudos to Alexander from StackOverflow! https://stackoverflow.com/a/39891965
    // PRECONDITION: `self` must be rectangular, i.e. every row has equal size.
    func transposed() -> [[Self.Iterator.Element.Iterator.Element]] {
        guard let firstRow = self.first else { return [] }
        return firstRow.indices.map { index in
            self.map{ $0[index] }
        }
    }
}

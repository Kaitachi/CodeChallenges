//
//  Set+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2023-01-09.
//

import Foundation

extension Set {
    func getElement<T: Hashable>(at coordinate: Cell2DIndex) -> T? {
        guard let collection = self as? Set<Cell2D<T>> else {
            return nil
        }
        
        return collection.filter { $0.row == coordinate.row && $0.col == coordinate.col }
            .first?.item
    }
}

//
//  Array+Extensions.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-12.
//

import Foundation

extension Array {
    func describe() {
        self.forEach { print($0) }
        print()
    }
}


// Methods to allow for handling arrays like queues
extension Array {
    mutating func enqueue(_ item: Element) {
        self.append(item)
    }
    
    mutating func dequeue() -> Element? {
        guard self.count > 0 else {
            return nil
        }
        
        return self.removeFirst()
    }
}


extension Array where Element: Equatable & Hashable {
    func allIndices(of value: Element) -> [Int] {
        indices.filter { self[$0] == value }
    }
    
    func sortedByFrequency() -> [Element] {
        let frequencies = self.reduce(into: [Element:Int]()) { currentResult, element in
            currentResult[element, default: 0] += 1
        }
        
        return self.sorted(by: { current, next in frequencies[current]! < frequencies[next]! })
    }
}

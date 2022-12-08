//
//  Node.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-07.
//

import Foundation

protocol Node {
    associatedtype Content
    
    var name: String { get set }
    var parent: (any Node)? { get set }
    var children: [(any Node)]? { get set }
    var data: Content? { get set }

    var isLeaf: Bool { get }
}

extension Node {
    func getFullPath(using delimiter: String = "/") -> String {
        return self.name // TODO: get full path! (not actually needed for this challenge...
    }
    
    var isLeaf: Bool {
        get {
            return self.children == nil
        }
    }
}

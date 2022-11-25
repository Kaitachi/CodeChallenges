//
//  AdventOfCode2021.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-24.
//

import Foundation
import ChallengeBase

// MARK: - Challenge Algorithms
enum AdventOfCode2021_Algorithms : String, CaseIterable {
    case part01
    case part02
}

// MARK: - Challenge Solutions
enum AdventOfCode2021_Solutions : String, CaseIterable {
    case Day01
    case Day02
    case Day03
}

class AdventOfCode2021 : Challenge {
    // MARK: - Type Aliases
    typealias Algorithms = AdventOfCode2021_Algorithms
    typealias Solutions = AdventOfCode2021_Solutions
        
    // MARK: - Abstract Factory Creator
    static func create(_ solution: Solutions) -> any Solution {
        switch solution {
        case .Day01:
            return AdventOfCode2021.Day01()
        case .Day02:
            return AdventOfCode2021.Day02()
        case .Day03:
            return AdventOfCode2021.Day03()
        }
    }
    
    // MARK: - Computed Properties
    var baseResourcePath: String {
        get {
            return #file
                .replacing(#"/Challenges/"#, with: "/Resources/")
                .replacing("/\(self.name).swift", with: "")
        }
    }
    
    var name: String {
        get { return String(String(describing: self).split(separator: ".")[1]) }
    }
}

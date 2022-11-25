//
//  AdventOfCode2021.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-24.
//

import ChallengeBase

// MARK: - Challenge Algorithms
enum AdventOfCode2021_Algorithms : String, CaseIterable {
    case part01
    case part02
}


// MARK: - Challenge Class
class AdventOfCode2021 : Challenge {
    // MARK: - Type Aliases
    typealias Algorithms = AdventOfCode2021_Algorithms
        
    
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

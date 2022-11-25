//
//  main.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-24.
//

import Foundation

let resourceSets = ["example"]

// MARK: - Direct Declaration
// Invoke using direct declarations
var declaredSolution = AdventOfCode2021.Day01(datasets: resourceSets, algorithms: [.part01, .part02])

declaredSolution.execute()


//// MARK: - Abstract Factory
//// Invoke using abstract factory
//var factorySolution = AdventOfCode2021.create(.Day01)
//factorySolution.setResourceSets(resourceSets)
//factorySolution.setAlgorithms([AdventOfCode2021_Algorithms.part01, AdventOfCode2021_Algorithms.part02])
//
//
//factorySolution.execute()



var day02 = AdventOfCode2021.Day02(datasets: resourceSets, algorithms: [.part01, .part02])
day02.execute()

var day03 = AdventOfCode2021.Day03(datasets: resourceSets, algorithms: [.part01, .part02])
day03.execute()

var day04 = AdventOfCode2021.Day04(datasets: resourceSets, algorithms: [.part01])
day04.execute()

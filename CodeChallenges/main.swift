//
//  main.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-11-24.
//

import Foundation

let datasets = ["example"]

// MARK: - Direct Declaration
// Invoke using direct declarations
var declaredSolution = AdventOfCode2021.Day01(datasets: datasets, algorithms: [.part01, .part02])

declaredSolution.execute()


// MARK: - Abstract Factory
// Invoke using abstract factory
var factorySolution = AdventOfCode2021.create(.Day01, datasets: datasets, algorithms: [.part01, .part02])

factorySolution.execute()

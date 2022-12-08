//
// 
//  AOC2022_Day07.swift
//  CodeChallenges
//
//  Created by Radamés Vega-Alfaro on 2022-12-07.
//
//

import ChallengeBase

extension AdventOfCode2022 {
    class Day07 : AdventOfCode2022, Solution {
        // MARK: - Type Aliases
        typealias Input = [Command]
        typealias Output = Int
        
        
        // MARK: - Properties
        var testCases: [TestCase<Input, Output>] = []
        var selectedResourceSets: [String] = []
        var selectedAlgorithms: [Algorithms] = []
        
        
        // MARK: - Initializers
        init(datasets: [String] = [], algorithms: [Algorithms] = []) {
            self.selectedResourceSets = datasets
            self.selectedAlgorithms = algorithms
        }
        
        
        // MARK: - Solution Methods
        // Step 1: Assemble
        func assemble(_ rawInput: String, _ rawOutput: String? = nil) -> (Input, Output?) {
            let formattedInput: [Command] = rawInput.replacingOccurrences(of: "$", with: "~\n$")
                .components(separatedBy: "~")
                .filter { !$0.isEmpty }
                .compactMap { segment in
                    var lines: [String] = segment.components(separatedBy: .newlines)
                        .filter { !$0.isEmpty }
                                                            
                    return (command: lines.removeFirst(), output: lines)
                }
            
            let formattedOutput = rawOutput?.integerList()[0]
            
            return (formattedInput, formattedOutput)
        }
        
        // Step 2: Activate
        func activate(_ input: Input, algorithm: Algorithms) -> Output {
            switch algorithm {
            case .part01:
                return part01(input)
            case .part02:
                return part02(input)
            }
        }
        
        
        // MARK: - Logic Methods
        func part01(_ inputData: Input) -> Output {
            let fileSystemTree = AdventOfCode2022.Day07.buildTree(with: inputData)
                        
            return AdventOfCode2022.Day07.flatten(tree: fileSystemTree)
                .filter { $0.isDirectory && $0.weight <= 100_000 }
                .reduce(0) { $0 + $1.weight }
        }
        
        func part02(_ inputData: Input) -> Output {
            let fileSystemTree = AdventOfCode2022.Day07.buildTree(with: inputData)
            let availableSpace = AdventOfCode2022.Day07.getAvailableSpace(from: fileSystemTree)
            let neededSpace = AdventOfCode2022.Day07.targetAvailableSpace - availableSpace
            
//            print("total size: \(fileSystemTree.weight)")
//            print("available space: \(availableSpace)")
//            print("need to delete: \(neededSpace)")
            
            return AdventOfCode2022.Day07.flatten(tree: fileSystemTree)
                .filter { $0.isDirectory && neededSpace <= $0.weight }
                .map { $0.weight }
                .sorted(by: < )
                .first!
        }
        
        
        // MARK: - Helper Methods
        typealias Command = (command: String, output: [String]?)
        
        static let diskSize: Int = 70_000_000
        static let targetAvailableSpace: Int = 30_000_000
        
        enum CommandName {
            case cd(String)
            case ls
        }
        
        enum CommandError: Error {
            case notACommand
            case invalidCommand
        }
        
        class FileSystemItem : Node {
            typealias Content = Int
            
            var name: String
            
            var parent: (any Node)?
            
            var children: [(any Node)]?
            
            var data: Content?
            
            init(name: String, parent: (any Node)? = nil) {
                self.name = name
                self.parent = parent
            }
            
            var isDirectory: Bool {
                return !self.isLeaf
            }
            
            var weight: Int {
                return self.children?
                    .reduce(0) { $0 + ($1 as! FileSystemItem).weight } ?? self.data!
            }
        }
        
        static func buildTree(with input: [Command]) -> FileSystemItem {
            let tree: FileSystemItem = FileSystemItem(name: "/")
            
            var cursor: any Node = tree
            
            for command in input {
                //print(command)
                switch try! getCommand(from: command.command) {
                case let .cd(directory):
                    if directory == "/" {
                        cursor = tree
                        
                        if cursor.children == nil {
                            cursor.children = []
                        }
                    } else if directory == ".." {
                        if let parent = cursor.parent {
                            cursor = parent
                        } else {
                            print("Directory .. does not exist!")
                        }
                    } else {
                        if let children = cursor.children {
                            cursor = children.first { $0.name == directory }!
                        }
                    }
                    
                case .ls:
//                    print("listing files: \(command.command)")
                    
                    if let output = command.output {
                        for line in output {
                            let parts = line.components(separatedBy: .whitespaces)
                            
                            switch parts[0] {
                            case "dir":
//                                print("creating directory...")
                                let directory = FileSystemItem(name: parts[1], parent: cursor)
                                directory.children = []
                                
                                cursor.children!.append(directory)
                                
                            default:
//                                print("creating file...")
                                let file = FileSystemItem(name: parts[1], parent: cursor)
                                file.data = Int(parts[0])!
                                
                                cursor.children!.append(file)
                            }
                        }
                    } else {
                        print("empty directory!")
                    }
                }
            }
            
//            print(tree)
            
            return tree
        }
        
        static func getCommand(from command: String) throws -> CommandName {
            let args = command.components(separatedBy: .whitespaces)
            
            guard args[0] == "$" else {
                throw CommandError.notACommand
            }
            
            switch args[1] {
            case "cd":
//                print("command: cd")
                return .cd(args[2])
                
            case "ls":
//                print("command: ls")
                return .ls
                
            default:
                throw CommandError.invalidCommand
            }
        }
        
        static func flatten(tree: FileSystemItem) -> [FileSystemItem] {
            var items: [FileSystemItem] = [FileSystemItem]()
            var remainingDirectories: [FileSystemItem] = [FileSystemItem]()
            var cursor: FileSystemItem? = tree

            repeat {
                if let children = cursor?.children as? [FileSystemItem] {
                    for child in children {
                        items.append(child)

                        if child.isDirectory {
                            remainingDirectories.append(child)
                        }
                    }
                }
                
                cursor = remainingDirectories.removeFirst()
            } while (0 < remainingDirectories.count)

            return items
        }
        
        static func getAvailableSpace(from tree: FileSystemItem) -> Int {
            return diskSize - tree.weight
        }
    }
}

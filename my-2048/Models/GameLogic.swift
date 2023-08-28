//
//  GameLogic.swift
//  DoubleNumbers
//
//  Created by Minh Vo on 16/08/2023.
//

import Foundation
import SwiftUI
import Combine

final class GameLogic : ObservableObject {
    @Published var score: Int = 0

    @Published public var currentLevel: Int = 1

    var boardSize: Int {
        switch currentLevel {
        case 1: return 4
        case 2: return 5
        case 3: return 6
        default: return 4
        }
    }
    
    enum Direction {
        case left
        case right
        case up
        case down
    }
    
    typealias BlockMatrixType = BlockMatrix<IdentifiedBlock>
    
    let objectWillChange = PassthroughSubject<GameLogic, Never>()
    
    fileprivate var _blockMatrix: BlockMatrixType!
    var blockMatrix: BlockMatrixType {
        return _blockMatrix
    }
    
    @Published fileprivate(set) var lastGestureDirection: Direction = .up
    
    fileprivate var _globalID = 0
    fileprivate var newGlobalID: Int {
        _globalID += 1
        return _globalID
    }
    
    init() {
        newGame()
        print("GameLogic initialized")
    }
    
    func newGame() {
        _blockMatrix = BlockMatrixType()
        resetLastGestureDirection()
        generateNewBlocks()
        objectWillChange.send(self)
        print("newGame funct initialized")
    }
    
    func resetLastGestureDirection() {
        lastGestureDirection = .up
    }
    
    func move(_ direction: Direction) {
        defer {
            objectWillChange.send(self)
        }
        
        lastGestureDirection = direction
        
        var moved = false
        
        let axis = direction == .left || direction == .right
        for row in 0..<boardSize {
            var rowSnapshot = [IdentifiedBlock?]()
            var compactRow = [IdentifiedBlock]()
            for col in 0..<boardSize {
                // Transpose if necessary.
                if let block = _blockMatrix[axis ? (col, row) : (row, col)] {
                    rowSnapshot.append(block)
                    compactRow.append(block)
                }
                rowSnapshot.append(nil)
            }
            
            merge(blocks: &compactRow, reverse: direction == .down || direction == .right)
            
            var newRow = [IdentifiedBlock?]()
            compactRow.forEach { newRow.append($0) }
            if compactRow.count < boardSize {
                for _ in 0..<(boardSize - compactRow.count) {
                    if direction == .left || direction == .up {
                        newRow.append(nil)
                    } else {
                        newRow.insert(nil, at: 0)
                    }
                }
            }
            
            newRow.enumerated().forEach {
                if rowSnapshot[$0]?.number != $1?.number {
                    moved = true
                }
                _blockMatrix.place($1, to: axis ? ($0, row) : (row, $0))
            }
        }
        
        if moved {
            generateNewBlocks()
        }
    }
    
    fileprivate func merge(blocks: inout [IdentifiedBlock], reverse: Bool) {
        if reverse {
            blocks = blocks.reversed()
        }
        
        blocks = blocks
            .map { (false, $0) }
            .reduce([(Bool, IdentifiedBlock)]()) { acc, item in
                if acc.last?.0 == false && acc.last?.1.number == item.1.number {
                    var accPrefix = Array(acc.dropLast())
                    var mergedBlock = item.1
                    mergedBlock.number *= 2
                    //Scoring system
                    score += mergedBlock.number
                    
                    accPrefix.append((true, mergedBlock))
                    return accPrefix
                } else {
                    var accTmp = acc
                    accTmp.append((false, item.1))
                    return accTmp
                }
            }
            .map { $0.1 }
        
        if reverse {
            blocks = blocks.reversed()
        }
        
    }
    
    @discardableResult fileprivate func generateNewBlocks() -> Bool {
        var blankLocations = [BlockMatrixType.Index]()
        for rowIndex in 0..<boardSize {
            for colIndex in 0..<boardSize {
                let index = (colIndex, rowIndex)
                if _blockMatrix[index] == nil {
                    blankLocations.append(index)
                }
            }
        }
        
        // If no blank locations, return false
        guard !blankLocations.isEmpty else {
            return false
        }
        
        // Don't forget to sync data.
        defer {
            objectWillChange.send(self)
        }
        
        // Place the first block.
        var placeLocIndex = Int.random(in: 0..<blankLocations.count)
        _blockMatrix.place(IdentifiedBlock(id: newGlobalID, number: 2), to: blankLocations[placeLocIndex])
        
        // If only one blank location, return true after placing the first block
        if blankLocations.count == 1 {
            return true
        }
        
        // Place the second block.
        guard let lastLoc = blankLocations.last else {
            return false
        }
        blankLocations[placeLocIndex] = lastLoc
        placeLocIndex = Int.random(in: 0..<(blankLocations.count - 1))
        _blockMatrix.place(IdentifiedBlock(id: newGlobalID, number: 2), to: blankLocations[placeLocIndex])
        
        return true
    }

    
//    fileprivate func forEachBlockIndices(mode: ForEachMode = .rowByRow,
//                                         reversed: Bool = false,
//                                         _ action: (BlockMatrixType.Index) -> ()) {
//        var indices = (0..<4).map { $0 }
//        if reversed {
//            indices = indices.reversed()
//        }
//
//        for row in indices {
//            for col in indices {
//                if mode == .rowByRow {
//                    action((col, row))
//                } else {
//                    action((row, col))  // transpose
//                }
//            }
//        }
//    }

    func setLevelValue(level: Int) {
        currentLevel = level
       // objectWillChange.send(self)
    }

    
    func hasPossibleMoves() -> Bool {
        // Check for empty blocks
        for rowIndex in 0..<boardSize {
            for colIndex in 0..<boardSize {
                let index = (colIndex, rowIndex)
                if _blockMatrix[index] == nil {
                    return true
                }
            }
        }
        
        // Check for possible merges
        for rowIndex in 0..<boardSize {
            for colIndex in 0..<boardSize {
                let currentBlock = _blockMatrix[(colIndex, rowIndex)]
                let rightBlock = colIndex < 3 ? _blockMatrix[(colIndex + 1, rowIndex)] : nil
                let downBlock = rowIndex < 3 ? _blockMatrix[(colIndex, rowIndex + 1)] : nil
                
                if (rightBlock != nil && rightBlock!.number == currentBlock!.number) ||
                   (downBlock != nil && downBlock!.number == currentBlock!.number) {
                    return true
                }
            }
        }
        
        return false
    }

}


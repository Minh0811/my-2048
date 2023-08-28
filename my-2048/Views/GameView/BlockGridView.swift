//
//  BlockGridView.swift
//  DoubleNumbers
//
//  Created by Minh Vo on 16/08/2023.
//

import SwiftUI

struct ScaledAnchorModifier: ViewModifier {
    let scaleValue: CGFloat
    let anchorPoint: UnitPoint
    
    func body(content: Content) -> some View {
        content.scaleEffect(scaleValue, anchor: anchorPoint)
    }
}

struct BlurModifier: ViewModifier {
    let blurValue: CGFloat
    
    func body(content: Content) -> some View {
        content.blur(radius: blurValue)
    }
}

struct CombinedModifiers<M1: ViewModifier, M2: ViewModifier>: ViewModifier {
    let modifier1: M1
    let modifier2: M2
    
    init(_ m1: M1, _ m2: M2) {
        self.modifier1 = m1
        self.modifier2 = m2
    }
    
    func body(content: Content) -> some View {
        content.modifier(modifier1).modifier(modifier2)
    }
}

extension AnyTransition {
    static func blockTransition(from edge: Edge, at position: CGPoint, within rect: CGRect) -> AnyTransition {
        let calculatedAnchor = UnitPoint(x: position.x / rect.width, y: position.y / rect.height)
        
        return .asymmetric(
            insertion: AnyTransition.opacity.combined(with: .move(edge: edge)),
            removal: AnyTransition.opacity.combined(with: .modifier(
                active: CombinedModifiers(
                    ScaledAnchorModifier(scaleValue: 0.8, anchorPoint: calculatedAnchor),
                    BlurModifier(blurValue: 20)
                ),
                identity: CombinedModifiers(
                    ScaledAnchorModifier(scaleValue: 1, anchorPoint: calculatedAnchor),
                    BlurModifier(blurValue: 0)
                )
            ))
        )
    }
}

struct BlockGridView : View {
    @EnvironmentObject var gameLogic: GameLogic
    
    typealias MatrixType = BlockMatrix<IdentifiedBlock>
    
    let matrix: Self.MatrixType
    let blockEnterEdge: Edge
    
    // New values for the grid's frame
    var currentLevel: Int {
            return gameLogic.currentLevel
        }
    
    var blockSettings: (dimension: CGFloat, gap: CGFloat) {
            switch currentLevel {
                //4x4
            case 1:
                return (60, 12)
                //5x5
            case 2:
                return (55, 12)
                //6x6
            case 3:
                return (50, 7)
            default:
                return (40, 12)  // Default values
            }
        }
        
        var blockDimension: CGFloat {
            return blockSettings.dimension
        }
        
        var gap: CGFloat {
            return blockSettings.gap
        }
        
        var gridWidth: CGFloat {
            return CGFloat(gameLogic.boardSize) * (blockDimension + gap) + gap
        }
        
        var gridHeight: CGFloat {
            return gridWidth // Since it's a square
        }
    
//    let blockDimension: CGFloat = 40
//    let gap: CGFloat = 12
//    var gridWidth: CGFloat {
//        return CGFloat(gameLogic.boardSize) * (blockDimension + gap) + gap
//    }
//    var gridHeight: CGFloat {
//        return gridWidth // Since it's a square
//    }
    
    func generateBlock(_ block: IdentifiedBlock?,
                     at index: (Int, Int)) -> some View {
        let position = CGPoint(
            x: CGFloat(index.0) * (blockDimension + gap) + blockDimension / 2 + gap,
            y: CGFloat(index.1) * (blockDimension + gap) + blockDimension / 2 + gap
        )
        
        let blockView = block.map(BlockView.init) ?? BlockView.emptyBlockView()
        
        return blockView
            .frame(width: blockDimension, height: blockDimension, alignment: .center)
            .position(x: position.x, y: position.y)
            .transition(.blockTransition(
                from: self.blockEnterEdge,
                at: CGPoint(x: position.x, y: position.y),
                within: CGRect(x: 0, y: 0, width: gridWidth, height: gridHeight)
            ))
    }
    
    func zIndex(_ block: IdentifiedBlock?) -> Double {
        return block == nil ? 1 : 1000
    }
    
    var body: some View {
        ZStack {
            // Background grid blocks:
            ForEach(0..<gameLogic.boardSize) { x in
                ForEach(0..<gameLogic.boardSize) { y in
                    self.generateBlock(nil, at: (x, y))
                }
            }
            .zIndex(1)
            
            // Number blocks:
            ForEach(self.matrix.flatten, id: \.item.id) {
                self.generateBlock($0.item, at: $0.index)
            }
            .zIndex(1000)
            .animation(.interactiveSpring(response: 0.4, dampingFraction: 0.8))
        }
        .frame(width: gridWidth, height: gridHeight, alignment: .center)
        .background(
            Rectangle()
                .fill(Color(red:0.72, green:0.66, blue:0.63, opacity:1.00))
        )
        .clipped()
        .cornerRadius(6)
        .drawingGroup(opaque: false, colorMode: .linear)
    }
    
}

#if DEBUG
struct BlockGridView_Previews : PreviewProvider {
    static var gameLogic = GameLogic()
    
    static var matrix: BlockGridView.MatrixType {
        var _matrix = BlockGridView.MatrixType(size: gameLogic.boardSize)
        _matrix.place(IdentifiedBlock(id: 1, number: 2), to: (2, 0))
        _matrix.place(IdentifiedBlock(id: 2, number: 2), to: (3, 0))
        _matrix.place(IdentifiedBlock(id: 3, number: 8), to: (1, 1))
        _matrix.place(IdentifiedBlock(id: 4, number: 4), to: (2, 1))
        _matrix.place(IdentifiedBlock(id: 5, number: 512), to: (3, 3))
        _matrix.place(IdentifiedBlock(id: 6, number: 1024), to: (2, 3))
        _matrix.place(IdentifiedBlock(id: 7, number: 16), to: (0, 3))
        _matrix.place(IdentifiedBlock(id: 8, number: 8), to: (1, 3))
        return _matrix
    }
    
    static var previews: some View {
        BlockGridView(matrix: matrix, blockEnterEdge: .top)
            .environmentObject(GameLogic())
            .previewLayout(.sizeThatFits)
    }
    
}
#endif

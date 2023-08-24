//
//  BlockView.swift
//  my-2048
//
//  Created by Minh Vo on 22/08/2023.
//

import SwiftUI

struct BlockView: View {
    
    fileprivate let blockNumber : Int?
    fileprivate let uniqueTextIdentifier: String?
    
    // MARK: - Initializers
    init(block: IdentifiedBlock) {
        self.blockNumber = block.number
        self.uniqueTextIdentifier = "\(block.id):\(block.number)"
    }

    fileprivate init() {
        self.blockNumber = nil
        self.uniqueTextIdentifier = ""
    }
    
    // MARK: - Computed Properties
    fileprivate var formattedNumber: String {
        guard let number = blockNumber else {
            return ""
        }
        return String(number)
    }
    
    fileprivate var fontSize: CGFloat {
        let textLength = formattedNumber.count
        switch textLength {
        case 0...2:
            return 32
        case 3:
            return 18
        default:
            return 12
        }
    }

    fileprivate var blockColors: (Color, Color) {
        // Return default color for blocks without a number.
        guard let number = blockNumber else {
            return DefaultBlockColorScheme
        }
        
        // Calculate the index based on the number of the block.
        let index = Int(log2(Double(number))) - 1
        
        // Ensure the index is within bounds.
        guard index >= 0, index < BlockColorScheme.count else {
            fatalError("No color for number \(number)")
        }
        
        return BlockColorScheme[index]
    }

    // MARK: - Body
    var body: some View {
        ZStack{
            Rectangle()
                .fill(blockColors.0) //BlockColorScheme[index].0
            Text(formattedNumber)
                .font(Font.system(size: fontSize).bold())
                .foregroundColor(blockColors.1) //BlockColorScheme[index].1
        }
    }
    
    // MARK: - Static Methods
    static func emptyBlockView() -> Self {
        return self.init()
    }
}

    // MARK: - Previews
struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(block: IdentifiedBlock(id: 3, number: 2))
    }
}

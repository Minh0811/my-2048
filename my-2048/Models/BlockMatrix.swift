//
//  BlockMatrix.swift
//  my-2048
//
//  Created by Minh Vo on 22/08/2023.
//

import SwiftUI
import Foundation

protocol Block {
    
    associatedtype Value
    
    var number: Value { get set }
    
}

struct BlockMatrix: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct BlockMatrix_Previews: PreviewProvider {
    static var previews: some View {
        BlockMatrix()
    }
}

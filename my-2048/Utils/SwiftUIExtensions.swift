//
//  SwiftUIExtensions.swift
//  DoubleNumbers
//
//  Created by Minh Vo on 16/08/2023.
//

import SwiftUI

extension View {
    
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
}

postfix operator >*
postfix func >*<V>(lhs: V) -> AnyView where V: View {
    return lhs.eraseToAnyView()
}

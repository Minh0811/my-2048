//
//  FunctionalUtils.swift
//  DoubleNumbers
//
//  Created by Minh Vo on 16/08/2023.
//

func bind<T, U>(_ x: T, _ closure: (T) -> U) -> U {
    return closure(x)
}


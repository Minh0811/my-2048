//
//  my_2048App.swift
//  my-2048
//
//  Created by Minh Vo Khai on 18/08/2023.
//

import SwiftUI

@main
struct my_2048App: App {
    // Initialize the GameLogic object once
    let gameLogic = GameLogic()
    
    var body: some Scene {
        WindowGroup {
            // Pass the gameLogic instance as an environment object to MenuView
            MenuView().environmentObject(gameLogic)
        }
    }
}

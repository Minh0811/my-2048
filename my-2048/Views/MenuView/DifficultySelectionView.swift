//
//  DifficultySelectionView.swift
//  my-2048
//
//  Created by Minh Vo on 24/08/2023.
//


import SwiftUI

struct DifficultySelectionView: View {
    @EnvironmentObject var gameLogic: GameLogic
    //@Binding var currentLevel: Int
    @State private var refreshView: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Difficulty")
                .font(.largeTitle)
                .padding()
            Text("Current Level: \(gameLogic.currentLevel)")
                      .font(.title2)
                      .padding()
            Button(action: {
                print("Easy button pressed")
                gameLogic.setLevelValue(level: 1)
                //gameLogic.currentLevel = 1
                print(gameLogic.currentLevel)
                refreshView.toggle()
                gameLogic.newGame()
            }) {
                Text("Easy (6x6)")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
 
            }

            Button(action: { print("Medium button pressed")
                gameLogic.setLevelValue(level: 2)
                refreshView.toggle()
                gameLogic.newGame()
            }) {
                Text("Medium (5x5)")
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                gameLogic.setLevelValue(level: 3)
                gameLogic.newGame()
            }) {
                Text("Hard (4x4)")
                    .font(.title)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .padding()
    }
}

struct DifficultySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DifficultySelectionView()
            .environmentObject(GameLogic())
    }
}

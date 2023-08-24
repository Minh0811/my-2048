//
//  DifficultySelectionView.swift
//  my-2048
//
//  Created by Minh Vo on 24/08/2023.
//


import SwiftUI

struct DifficultySelectionView: View {
    @EnvironmentObject var gameLogic: GameLogic

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Difficulty")
                .font(.largeTitle)
                .padding()

            Button(action: {
                gameLogic.currentLevel = 3
               // GameView()
            }) {
                Text("Easy (6x6)")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                gameLogic.currentLevel = 2
            }) {
                Text("Medium (5x5)")
                    .font(.title)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button(action: {
                gameLogic.currentLevel = 1
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
    }
}

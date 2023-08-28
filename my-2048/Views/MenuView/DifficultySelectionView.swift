//
//  DifficultySelectionView.swift
//  my-2048
//
//  Created by Minh Vo on 24/08/2023.
//


import SwiftUI

//struct ParentView: View {
//    @State private var gameLogic = GameLogic()
//    @State private var showGame = false
//    @State private var uniqueID = UUID()
//    var body: some View {
//        VStack {
//            if showGame {
//                GameView()
//                    .environmentObject(gameLogic)
//            } else {
//                DifficultySelectionView(reinitializeGameLogic: {
//                    self.gameLogic = GameLogic()
//                    self.uniqueID = UUID()
//                    self.showGame = true
//                })
//                .environmentObject(gameLogic)
//            }
//        }
//    }
//}

struct DifficultySelectionView: View {
    @EnvironmentObject var gameLogic: GameLogic
   // var reinitializeGameLogic: () -> Void
    //@Binding var currentLevel: Int
    @State private var refreshView: Bool = false
  //  @State var DifficultyLevel = 3
   // @Binding var currentLevel: Int
    
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
                gameLogic.setLevelValue(level: 3)
                //gameLogic.currentLevel = 1
                print("Ez: \(gameLogic.currentLevel)")
                //refreshView.toggle()
        //        reinitializeGameLogic()
                gameLogic.newGame()
         
           
            }) {
                Text("Easy (6x6)")
                    .font(.title)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
 
            }

            Button(action: {
                print("Medium button pressed")
                gameLogic.setLevelValue(level: 2)
                print("Medium: \(gameLogic.currentLevel)")
               // refreshView.toggle()
          //      reinitializeGameLogic()
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
                print("Hard button pressed")
                gameLogic.setLevelValue(level: 1)
                print("Hard: \(gameLogic.currentLevel)")
        //        reinitializeGameLogic()
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
    @State static var dummyCurrentLevel: Int = 1
        static var dummyGameLogic = GameLogic()

    static var previews: some View {
           DifficultySelectionView() // Provide an empty closure for the preview
               .environmentObject(GameLogic())
        
       }
}

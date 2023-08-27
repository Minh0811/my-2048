//
//  MenuView.swift
//  my-2048
//
//  Created by Minh Vo on 24/08/2023.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var gameLogic: GameLogic
    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
                Text("Select Difficulty")
                    .font(.largeTitle)
                    .padding()
                
//                Button(action: {
//                    
//                    GameView()
//                    
//                }) {
//                    Text("Game")
//                        .font(.title)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
                
                NavigationLink(
                    destination: GameView().environmentObject(GameLogic()),
                    label: {
                        Text("Game")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        
                    }
                )
                
                NavigationLink(
                    destination: DifficultySelectionView() .environmentObject(GameLogic()),
                    label: {
                        Text("Choose dificult")
                            .font(.title)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)              }
                )
                
                Button(action: {
                    
                }) {
                    Text("Setting")
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
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(GameLogic())
    }
}

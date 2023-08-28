//
//  GameView.swift
//  DoubleNumbers
//
//  Created by Minh Vo on 16/08/2023.
//

import SwiftUI

extension Edge {
    
    static func from(_ from: GameLogic.Direction) -> Self {
        switch from {
        case .down:
            return .top
        case .up:
            return .bottom
        case .left:
            return .trailing
        case .right:
            return .leading
        }
    }
    
}

struct GameView : View {
    
    @State var ignoreGesture = false
    
    @State private var isGameOver = false
    
    @EnvironmentObject var gameLogic: GameLogic
    
    fileprivate struct LayoutTraits {
        let bannerOffset: CGSize
        let showsBanner: Bool
        let containerAlignment: Alignment
    }
    
    fileprivate func layoutTraits(`for` proxy: GeometryProxy) -> LayoutTraits {
#if os(macOS)
        let landscape = false
#else
        let landscape = proxy.size.width > proxy.size.height
#endif
        
        return LayoutTraits(
            bannerOffset: landscape
            ? .init(width: 32, height: 0)
            : .init(width: 0, height: 32),
            showsBanner: landscape ? proxy.size.width > 720 : proxy.size.height > 550,
            containerAlignment: landscape ? .leading : .top
        )
    }
    
    var gestureEnabled: Bool {
        // Existed for future usage.
#if os(macOS) || targetEnvironment(macCatalyst)
        return false
#else
        return true
#endif
    }
    
    var gesture: some Gesture {
        let threshold: CGFloat = 44
        let drag = DragGesture()
            .onChanged { v in
                guard !self.ignoreGesture else { return }
                
                guard abs(v.translation.width) > threshold ||
                        abs(v.translation.height) > threshold else {
                    return
                }
                
                withTransaction(Transaction(animation: .spring())) {
                    self.ignoreGesture = true
                    
                    if v.translation.width > threshold {
                        // Move right
                        self.gameLogic.move(.right)
                    } else if v.translation.width < -threshold {
                        // Move left
                        self.gameLogic.move(.left)
                    } else if v.translation.height > threshold {
                        // Move down
                        self.gameLogic.move(.down)
                    } else if v.translation.height < -threshold {
                        // Move up
                        self.gameLogic.move(.up)
                    }
                    if !self.gameLogic.hasPossibleMoves() {
                        self.isGameOver = true
                    }
                }
            }
            .onEnded { _ in
                self.ignoreGesture = false
            }
        return drag
    }
    
    var content: some View {
        GeometryReader { proxy in
            bind(self.layoutTraits(for: proxy)) { layoutTraits in
                ZStack(alignment: layoutTraits.containerAlignment) {
                    VStack{
                        if layoutTraits.showsBanner {
                            Text("2048")
                                .font(Font.system(size: 48).weight(.black))
                                .foregroundColor(Color(red:0.47, green:0.43, blue:0.40, opacity:1.00))
                                .offset(layoutTraits.bannerOffset)
                            
                        }
                        Text("Score: \(self.gameLogic.score)")
                            .font(.title)
                            .padding()
                        Text("Current Level: \(gameLogic.currentLevel)")
                                  .font(.title2)
                                  .padding()
                    }
                    ZStack(alignment: .center) {
                        BlockGridView(matrix: self.gameLogic.blockMatrix,
                                      blockEnterEdge: .from(self.gameLogic.lastGestureDirection))
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(
                    Rectangle()
                        .fill(Color(red:0.96, green:0.94, blue:0.90, opacity:1.00))
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }
    
    var body: some View {
        if gestureEnabled {
            return AnyView(
                content
                    .gesture(gesture, including: .all)
                    .alert(isPresented: $isGameOver) {
                        Alert(title: Text("Game Over"), message: Text("No possible moves left!"), dismissButton: .default(Text("New Game")) {
                            gameLogic.newGame()
                            isGameOver = false
                            self.gameLogic.score = 0
                            
                        })
                    }
            )
        } else {
            return AnyView(content)
        }
    }
    
    
}

#if DEBUG
struct GameView_Previews : PreviewProvider {
    
    static var previews: some View {
        GameView()
            .environmentObject(GameLogic())
    }
    
}
#endif


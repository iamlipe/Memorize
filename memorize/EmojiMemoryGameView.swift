//
//  ContentView.swift
//  memorize
//
//  Created by Felipe Lima on 25/07/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
  @ObservedObject var game: EmojiMemoryGame
  
  @Namespace private var dealingNamespace
  
  @State private var dealt = Set<Int>()
  
  private func deal(_ card: EmojiMemoryGame.Card) {
    dealt.insert(card.id)
  }
  
  private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
    !dealt.contains(card.id)
  }
  
  private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
    var delay = 0.0
    if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
      delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
    }
    
    return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
  }
  
  private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
    -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack {
        gameBody
        
        HStack {
          shuffle
          Spacer()
          restart
        }
        .padding(.horizontal)
      }
      deckBody
    }
    .padding()
    
  }
  
  var gameBody: some View {
    AspectVGrid(items: game.cards, aspectRatio: 2 / 3, content: { card in
      if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
        Color.clear
      } else {
        CardView(card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .padding(4)
          .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
          .zIndex(zIndex(of: card))
          .onTapGesture {
            withAnimation {
              game.choose(card)
            }
          }
      }
    })
    .foregroundColor(.blue)
  }
  
  var deckBody: some View {
    ZStack {
      ForEach(game.cards.filter(isUndealt)) { card in
        CardView(card)
          .matchedGeometryEffect(id: card.id, in: dealingNamespace)
          .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
        
      }
    }
    .frame(width: CardConstants.undealWeigth, height: CardConstants.undealHeight)
    .foregroundColor(CardConstants.color)
    .onTapGesture {
      for card in game.cards {
        withAnimation(dealAnimation(for: card)) {
          deal(card)
        }
      }
    }
  }
  
  var shuffle: some View {
    Button("Shuffle", action: {
      withAnimation {
        game.shuffle()
      }
    })
  }
  
  var restart: some View {
    Button("Restart", action: {
      withAnimation {
        dealt = []
        game.restart()
      }
    })
  }
  
  
  private struct CardConstants {
    static let color = Color.blue
    static let aspectRatio: CGFloat = 2/3
    static let dealDuration: Double = 0.3
    static let totalDealDuration: Double = 2
    static let undealHeight: CGFloat = 90
    static let undealWeigth = undealHeight * aspectRatio
  }
}

struct CardView: View {
  private let card: EmojiMemoryGame.Card
  
  @State private var animatedBonusRemaining: Double = 0
  
  init(_ card: EmojiMemoryGame.Card) {
    self.card = card
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Group {
          if card.isConsumingBonusTime {
            Pie(startAngle: Angle(degrees: 0-90),endAngle: Angle(degrees: (1-animatedBonusRemaining)*360-90))
              .onAppear {
                animatedBonusRemaining = card.bonusRemaining
                
                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                  animatedBonusRemaining = 0
                }
              }
            
          } else {
            Pie(startAngle: Angle(degrees: 0-90),endAngle: Angle(degrees: (1-card.bonusRemaining)*360-90))
          }
        }
        .padding(6)
        .opacity(0.5)
        Text(card.content)
          .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
          .animation(Animation.linear(duration: 0.6).repeatForever(autoreverses: true), value: card.isMatched)
          .font(Font.system(size: DrawingConstants.fontSize))
          .scaleEffect(scale(thatFits: geometry.size))
      }
      .cardify(isFaceUp: card.isFaceUp)
    }
  }
  
  private func scale(thatFits size: CGSize) -> CGFloat {
    min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
  }
  
  private enum DrawingConstants {
    static let fontScale: CGFloat = 0.6
    static let fontSize: CGFloat = 32
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame()
    EmojiMemoryGameView(game: game)
  }
}

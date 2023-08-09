//
//  EmojiMemoryGame.swift
//  memorize
//
//  Created by Felipe Lima on 27/07/23.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
  typealias Card = MemoryGame<String>.Card

  private static let emojis: Array<String> = ["🐶", "🐸", "🐷", "🦁", "🐭", "🐱", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🐮", "🐽", "🐻‍❄️"]
  
  private static func createMemoryGame() -> MemoryGame<String> {
    MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in
      emojis[pairIndex]
    }
  }
    
  @Published private var model = createMemoryGame()
  
  var cards: Array<Card> {
    return model.cards
  }
    
  func choose(_ card: Card) {
    model.choose(card)
  }
  
  func shuffle() {
    model.shuffle()
  }
  
  func restart() {
    model = EmojiMemoryGame.createMemoryGame()
  }
}

//
//  memorizeApp.swift
//  memorize
//
//  Created by Felipe Lima on 25/07/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
  private let game = EmojiMemoryGame()
  
  var body: some Scene {
    WindowGroup {
      EmojiMemoryGameView(game: game)
    }
  }
}

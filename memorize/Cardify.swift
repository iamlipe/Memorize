//
//  Cardfy.swift
//  memorize
//
//  Created by Felipe Lima on 02/08/23.
//

import SwiftUI

struct Cardify: AnimatableModifier {
  var rotation: Double
  
  var animatableData: Double {
    get { rotation }
    set { rotation = newValue }
  }
  
  init(isFaceUp: Bool) {
    self.rotation = isFaceUp ? 0 : 180
  }
  
  func body(content: Content) -> some View {
    ZStack {
      let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
      

      if rotation < 90 {
        shape.foregroundColor(.white)
        shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
      } else {
        shape.fill()
      }
      
      content.opacity(rotation < 90 ? 1 : 0)
    }.rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
  }
  
  private enum DrawingConstants {
    static let cornerRadius: CGFloat = 12
    static let lineWidth: CGFloat = 2
  }
}

extension View {
  func cardify(isFaceUp: Bool) -> some View {
    return self.modifier(Cardify(isFaceUp: isFaceUp))
  }
}

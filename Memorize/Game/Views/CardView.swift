//
//  CardView.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

struct CardView: View {
    let card: GameModel<String>
    let base = RoundedRectangle(cornerRadius: 12)
    init(_ card: GameModel<String>) {
        self.card = card
    }
    
    var body: some View {
        ZStack(alignment: .center){
            Group{
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.1)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

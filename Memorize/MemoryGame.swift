//
//  MemorizeGame.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/22/25.
//

import Foundation

struct MemoryGame<CardContent>{
    private(set) var cards: Array<Card>
    
    init(numberOfPairOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = []
        for pairIndex in 0..<max(2, numberOfPairOfCards){
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func shuffle() {
        
    }
    func choose(_ card: Card){
        
    }
    
    struct Card{
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
    }
}

//
//  CardsModel.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import Foundation

struct GameModel<CardContent>: Equatable, Identifiable where CardContent: Equatable {
    
    let content: CardContent
    var isFaceUp = false
    var isMatched = false
    var previouslySeen = false
    var id: String
}

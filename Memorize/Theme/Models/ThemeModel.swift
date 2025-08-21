//
//  ThemeModel.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import Foundation

struct ThemeModel: Codable, Identifiable {
    let id: UUID
    let displayName: String
    let associatedColor: ColorModel
    let description: String
    let emojiElements: [String]
    let isRandomized: Bool
    let amountOfCardsChosen: Int
    
    var numberOfPair: Int {
        let count = emojiElements.count
        switch isRandomized {
        case false:
            return amountOfCardsChosen / 2
        case true:
            return count > 0 ? Int.random(in: 1...count) : 0
        }
    }
    
    var amountOfCards: Int? {
        switch isRandomized {
        case true:
            return nil
        case false:
            return (amountOfCardsChosen % 2 == 0) ? amountOfCardsChosen : amountOfCardsChosen - 1
        }
    }
}

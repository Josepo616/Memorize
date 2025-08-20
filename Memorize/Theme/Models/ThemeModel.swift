//
//  ThemeModel.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import Foundation

struct ThemeModel {
    let id: UUID
    let displayName: String
    let associatedColor: ColorModel
    let description: String
    let emojiElements: [String]
    let isRandomized: Bool
    
    var numberOfPair: Int {
        let count = emojiElements.count
        switch isRandomized {
        case false:
            return emojiElements.count
        case true:
            return count > 0 ? Int.random(in: 1...count) : 0
        }
    }
    
    var amountOfCards: Int {
        let count = emojiElements.count
        switch displayName.lowercased() {
        case "halloween", "animals", "food", "cars", "flags", "sports":
            return count * 2
        default:
            return 0
        }
    }
}

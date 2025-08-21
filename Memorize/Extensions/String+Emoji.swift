//
//  String+Emoji.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import Foundation

extension String {
    func getUniqueEmoji() -> String {
        var seenEmojis = Set<Character>()
        var result = ""
        for character in self {
            if character.isEmoji {
                if !seenEmojis.contains(character) {
                    seenEmojis.insert(character)
                    result.append(character)
                }
            }
        }
        return result
    }
}

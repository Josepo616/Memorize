//
//  ListContent.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/22/25.
//

import SwiftUI

struct ListContent: View {
    let theme: ThemeModel

    var body: some View {
        Text(theme.displayName)
            .font(.headline)
            .foregroundColor(theme.associatedColor.swiftUIColor)
        Text(theme.emojiElements.prefix(10).joined(separator: " "))
            .font(.body)
        Text(
            theme.amountOfCards.map { "Max amount of cards: \($0)" }
                ?? "You are using a random amount of cards"
        )
        .font(.footnote)
    }
}

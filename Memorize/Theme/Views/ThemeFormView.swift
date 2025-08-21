//
//  NewThemeView.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

struct ThemeFormView: View {
    @ObservedObject var viewModel: ThemeViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: FoucusCases.FocusField?
    @State private var title: String = ""
    @State private var emojiContent: String = ""
    @State private var color: Color = .blue
    @State private var randomAmount: Bool = true
    @State private var amountOfCards: Int = 2
    @Binding var themeId: UUID?

    var body: some View {
        Form {

            Section(header: Text("Theme name")) {
                TextField("Enter theme name", text: $title)
                    .focused($focused, equals: .name)
            }

            Section(header: Text("Emojis content")) {
                TextField("Add emojis here", text: $emojiContent)
                    .focused($focused, equals: .emoji)
                    .onChange(of: emojiContent) { oldValue, newValue in
                        viewModel.validationForContent(&emojiContent, newValue)
                    }
            }
            

            ColorSection(color: $color)
            RandomizationSection(randomAmount: $randomAmount)
            
            if !randomAmount {
                AmountOfCardsToShow(amountOfCards: $amountOfCards)
            }

            ActionButton(
                themeId: themeId,
                title: title,
                emojiContent: emojiContent,
                color: color,
                randomAmount: randomAmount,
                amountOfCards: amountOfCards,
                viewModel: viewModel
            )
        }
        .onAppear {
            viewModel.loadExistingTheme(
                themeId: themeId,
                title: $title,
                emojiContent: $emojiContent,
                color: $color,
                randomAmount: $randomAmount,
                amountOfCards: $amountOfCards
            )
        }
        .onDisappear { themeId = nil }
    }
}

/*
#Preview {
    NewThemeView(viewModel: ThemeViewModel())
}*/

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
    @Binding var themeId: UUID?
    @State private var title: String = ""
    @State var emojiContent: String = ""
    @State var deletedEmojis: String = ""
    @State private var color: Color = .blue
    @State private var randomAmount: Bool = true
    @State private var amountOfCards: Int = 2
    @State private var showDeleted: Bool = false
    @State private var recoverEmoji: Bool = false

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
            RandomizationSection(randomAmount: $randomAmount, amountOfCards: $amountOfCards, emojiContent: $emojiContent, viewModel: viewModel)
            DeletedSection(showDeleted: $showDeleted, deletedEmojis: $deletedEmojis, recoverEmoji: $recoverEmoji)
            
            ActionButton(
                viewModel: viewModel,
                themeId: themeId,
                title: title,
                emojiContent: emojiContent,
                color: color,
                randomAmount: randomAmount,
                amountOfCards: amountOfCards,
                recoverEmoji: recoverEmoji
            )
        }
        .onAppear {
            viewModel.loadExistingTheme(
                themeId: themeId,
                title: $title,
                emojiContent: $emojiContent,
                color: $color,
                randomAmount: $randomAmount,
                amountOfCards: $amountOfCards,
                emojiDeleted: $deletedEmojis
            )
        }
        .onDisappear { themeId = nil }
    }
}

/*
#Preview {
    NewThemeView(viewModel: ThemeViewModel())
}*/

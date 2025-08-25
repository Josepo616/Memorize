//
//  ActionButton.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import SwiftUI

struct ActionButton: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ThemeViewModel

    var themeId: UUID?
    var title: String
    var emojiContent: String
    var color: Color
    var randomAmount: Bool
    var amountOfCards: Int
    var recoverEmoji: Bool

    var body: some View {
        Section(header: Text("Options")) {
            Button(themeId == nil ? "Add Theme" : "Save Changes") {
                saveOrUpdateTheme(recoverEmoji)
            }
            .disabled(
                title.isEmpty
                    || emojiContent.count < 2
                        && (randomAmount ? true : amountOfCards < 4)
            )
        }
    }

    private func saveOrUpdateTheme(_ recoverEmoji: Bool) {
        let newEmojiElements = emojiContent.filter { $0.isEmoji }.map { String($0) }
        
        if let rgb = color.getRGBComponents() {
            let newColorModel = ColorModel(
                red: Double(rgb.red),
                green: Double(rgb.green),
                blue: Double(rgb.blue),
                alpha: Double(rgb.alpha)
            )
            
            let newThemeModel = ThemeModel(
                id: themeId ?? UUID(),
                displayName: title,
                associatedColor: newColorModel,
                description: "You're playing " + title + "'s theme",
                emojiElements: newEmojiElements,
                emojiElementsDeleted: [],
                isRandomized: randomAmount,
                amountOfCardsChosen: amountOfCards
            )
            
            if themeId != nil {
                viewModel.updateTheme(
                    newThemeModel,
                    recoverEmoji,
                    newEmojiElements
                    
                )
            } else {
                viewModel.addTheme(newThemeModel)
            }
            
            dismiss()
        }
    }
}

//
//  ActionButton.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import SwiftUI

struct ActionButton: View {
    var themeId: UUID?
    var title: String
    var emojiContent: String
    var color: Color
    var randomAmount: Bool
    var amountOfCards: Int

    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ThemeViewModel

    var body: some View {
        Button(themeId == nil ? "Add Theme" : "Save Changes") {
            saveOrUpdateTheme()
        }
        .disabled(title.isEmpty || emojiContent.count < 2 || amountOfCards < 4)
    }

    private func saveOrUpdateTheme() {
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
                description: "New theme added",
                emojiElements: emojiContent.filter { $0.isEmoji }.map {
                    String($0)
                },
                isRandomized: randomAmount,
                amountOfCardsChosen: amountOfCards
            )

            if themeId != nil {
                viewModel.updateTheme(newThemeModel)
            } else {
                viewModel.addTheme(newThemeModel)
            }
            dismiss()
        }
    }
}

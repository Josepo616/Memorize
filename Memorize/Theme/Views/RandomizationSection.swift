//
//  RandomizationSection.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import SwiftUI

struct RandomizationSection: View {

    @Binding var randomAmount: Bool
    @Binding var amountOfCards: Int
    @Binding var emojiContent: String
    @ObservedObject var viewModel: ThemeViewModel

    var body: some View {
        Section(header: Text("Randomization")) {
            Toggle("Random amount of cards", isOn: $randomAmount)

            if !randomAmount {
                TextField(
                    "Enter the amount of cards, consider max",
                    value: $amountOfCards,
                    format: .number
                )
                .onChange(of: amountOfCards) { oldValue, newValue in
                    viewModel.validationForAmountOfCards(
                        &amountOfCards,
                        newValue,
                        emojiContent
                    )
                }
            }
        }
    }
}

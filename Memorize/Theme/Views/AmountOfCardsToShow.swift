//
//  AmountOfCardsToShow.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import SwiftUI

struct AmountOfCardsToShow: View {
    @Binding var amountOfCards: Int
    @Binding var emojiContent: String
    @ObservedObject var viewModel: ThemeViewModel
    
    var body: some View {
        Section(header: Text("Amount of cards")) {
            TextField("Enter the amount of cards, consider max", value: $amountOfCards, format: .number)
                .onChange(of: amountOfCards) { oldValue, newValue in
                    viewModel.validationForAmountOfCards(&amountOfCards, newValue, emojiContent)
                }
        }
    }
}

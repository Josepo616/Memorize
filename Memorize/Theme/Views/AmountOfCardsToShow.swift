//
//  AmountOfCardsToShow.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import SwiftUI

struct AmountOfCardsToShow: View {
    @Binding var amountOfCards: Int
    
    var body: some View {
        Section(header: Text("Amount of cards")) {
            TextField("Enter the amount of cards, consider max", value: $amountOfCards, format: .number)
        }
    }
}

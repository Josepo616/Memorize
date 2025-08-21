//
//  RandomizationSection.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import SwiftUI

struct RandomizationSection: View {
    @Binding var randomAmount: Bool

    var body: some View {
        Section(header: Text("Randomization")) {
            Toggle("Random amount of cards", isOn: $randomAmount)
        }
    }
}

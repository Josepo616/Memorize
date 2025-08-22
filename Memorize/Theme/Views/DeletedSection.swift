//
//  DeletedSection.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/22/25.
//

import SwiftUI

struct DeletedSection: View {
    @Binding var showDeleted: Bool
    @Binding var deletedEmojis: String
    @Binding var recoverEmoji: Bool

    var body: some View {
        Section(header: Text("Emojis Deleted")) {
            Toggle("Enable to see deleted emojis", isOn: $showDeleted)

            if showDeleted {
                HStack {
                    TextField(
                        "You don't have any emojis",
                        text: $deletedEmojis
                    )
                    .disabled(true)
                    Spacer()
                    Toggle("Recover them", isOn: $recoverEmoji)
                        .multilineTextAlignment(.center)
                        .scaleEffect(0.8)
                        .padding(.leading, 20)
                }
            }
        }
    }
}

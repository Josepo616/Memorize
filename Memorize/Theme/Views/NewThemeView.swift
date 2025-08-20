//
//  NewThemeView.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

struct NewThemeView: View {
    @ObservedObject var viewModel: ThemeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var emojiContent: String = ""
    @State private var color: Color = .blue
    @State private var randomAmount: Bool = true
    private let emojiFont = Font.system(size: 20)
    
    var onAdd: (String) -> Void
    
    enum Focused {
        case name, addEmoji
    }
    
    @FocusState private var focused: Focused?
    
    var body: some View {
        Form {
            Section(header: Text("Theme name")) {
                TextField("Name", text: $title)
                    .focused($focused, equals: .name)
            }
            
            Section(header: Text("Emojis content")) {
                TextField("Add emojis here", text: $emojiContent)
                    .focused($focused, equals: .addEmoji)
                    .font(emojiFont)
            }
            
            Section(header: Text("Theme Color")) {
                ColorPicker("Choose a color", selection: $color)
            }
            
            Section(header: Text("Randomization")) {
                Toggle("Random amount of cards", isOn: $randomAmount)
            }
            Button("Add Theme") {
                let newThemeModel = ThemeModel(
                    id: UUID(),
                    displayName: title,
                    associatedColor: color.description,
                    description: "New theme added",
                    emojiElements: emojiContent.filter { $0.isEmoji }.map { String($0) },
                    isRandomized: randomAmount
                )
                viewModel.addTheme(newThemeModel)
                dismiss()
            }
            .disabled(title.isEmpty || emojiContent.isEmpty)
        }
    }
}

#Preview {
    NewThemeView(viewModel: ThemeViewModel(), onAdd: { newTheme in })
}

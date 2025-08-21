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

    @Binding var themeId: UUID?

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

            Button(themeId == nil ? "Add Theme" : "Save Changes") {
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
                        isRandomized: randomAmount
                    )

                    if let themeId = themeId {
                        viewModel.updateTheme(newThemeModel)
                    } else {
                        viewModel.addTheme(newThemeModel)
                    }
                }
                dismiss()
            }
            .disabled(title.isEmpty || emojiContent.isEmpty)
        }
        .onAppear {
            if let themeId = themeId {
                if let existingTheme = viewModel.getThemeById(themeId) {
                    print(existingTheme.associatedColor)
                    title = existingTheme.displayName
                    emojiContent = existingTheme.emojiElements.joined()
                    color = Color.rgb(
                        red: existingTheme.associatedColor.red,
                        green: existingTheme.associatedColor.green,
                        blue: existingTheme.associatedColor.blue,
                        alpha: existingTheme.associatedColor.alpha
                    )
                    randomAmount = existingTheme.isRandomized
                }
            }
        }
        .onDisappear {
            themeId = nil
        }
    }
}

/*
#Preview {
    NewThemeView(viewModel: ThemeViewModel())
}*/

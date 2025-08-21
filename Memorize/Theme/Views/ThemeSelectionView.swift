//
//  SwiftUIView.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

struct ThemeSelectionView: View {
    @ObservedObject var viewModel: ThemeViewModel
    @State private var isPopoverVisible = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.themes, id: \.id) { themeModel in
                    NavigationLink(
                        destination: GameView(
                            theme: themeModel,
                            themeViewModel: viewModel
                        )
                    ) {
                        VStack(alignment: .leading) {
                            listContent(themeModel)
                        }
                        .padding()
                        .contextMenu {
                            themeContextMenu(for: themeModel)
                        }
                    }
                }
            }
            .navigationTitle("Select a Theme")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddThemeButton
                }
            }
        }
    }

    private func themeContextMenu(for themeModel: ThemeModel) -> some View {
        VStack {
            Button(action: {
                viewModel.selectedThemeId = themeModel.id
                isPopoverVisible.toggle()
                print(
                    "selectedThemeId en ThemeSelectionView: \(String(describing: viewModel.selectedThemeId))"
                )  // Verifica aquí
            }) {
                Text("Edit")
                Image(systemName: "pencil")
            }

            Button(action: {
                viewModel.deleteTheme(themeModel.id)
            }) {
                Text("Delete")
                Image(systemName: "trash")
            }
        }
    }

    var AddThemeButton: some View {
        Button {
            isPopoverVisible.toggle()
        } label: {
            Text("Add Theme")
            Image(systemName: "plus.square.fill.on.square.fill")
        }
        .popover(isPresented: $isPopoverVisible) {
            if let themeId = viewModel.selectedThemeId,
                let themeToEdit = viewModel.getThemeById(themeId)
            {
                ThemeFormView(
                    viewModel: viewModel,
                    themeId: $viewModel.selectedThemeId
                )
            } else {
                ThemeFormView(
                    viewModel: viewModel,
                    themeId: $viewModel.selectedThemeId
                )
            }
        }
    }

    @ViewBuilder
    func listContent(_ theme: ThemeModel) -> some View {
        Text(theme.displayName)
            .font(.headline)
            .foregroundColor(Colors().mapColor(theme.associatedColor))
        Text(theme.emojiElements.prefix(10).joined(separator: " "))
            .font(.body)
        Text(
            (theme.amountOfCards != nil)
                ? "Max amount of cards: \(theme.amountOfCards!)"
                : "You are using a random amount"
        )
        .font(.footnote)

    }
}

#Preview {
    ThemeSelectionView(viewModel: ThemeViewModel())
}

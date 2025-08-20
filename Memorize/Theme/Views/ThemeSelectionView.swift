//
//  SwiftUIView.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

struct ThemeSelectionView: View {
    @State private var isPopoverVisible = false
    @ObservedObject var viewModel: ThemeViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.themes, id: \.id) { themeModel in
                    NavigationLink(destination: GameView(theme: themeModel, themeViewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            listContent(themeModel)
                        }
                        .padding()
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

    var AddThemeButton: some View {
        Button {
            isPopoverVisible.toggle()
        } label: {
            Text("Add Theme")
            Image(systemName: "plus.square.fill.on.square.fill")
        }
        .popover(isPresented: $isPopoverVisible) {
            NewThemeView(viewModel: viewModel, onAdd: { newThemeName in
                let themeModel = viewModel.createTheme(named: newThemeName)
                viewModel.addTheme(themeModel)
                isPopoverVisible = false
            })
        }
    }

    @ViewBuilder
    func listContent(_ theme: ThemeModel) -> some View {
        Text(theme.displayName)
            .font(.headline)
            .foregroundColor(viewModel.mapColor(theme.associatedColor))
        Text(theme.emojiElements.joined(separator: " "))
            .font(.body)
        Text("Max ammount of cards: \(theme.amountOfCards)")
            .font(.footnote)
    }
}

#Preview {
    ThemeSelectionView(viewModel: ThemeViewModel())
}

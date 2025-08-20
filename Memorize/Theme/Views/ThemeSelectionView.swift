//
//  SwiftUIView.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

struct ThemeSelectionView: View {
    @ObservedObject var viewModel: ThemeViewModel
    @State private var selectedThemeId: UUID?
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
                selectedThemeId = themeModel.id
                isPopoverVisible.toggle()
                print("selectedThemeId en ThemeSelectionView: \(String(describing: selectedThemeId))")  // Verifica aquí
            }) {
                Text("Editar")
                Image(systemName: "pencil")
            }
            
            Button(action: {
                viewModel.deleteTheme(themeModel.id)
            }) {
                Text("Eliminar")
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
            if let themeId = selectedThemeId, let themeToEdit = viewModel.getThemeById(themeId) {
                NewThemeView(viewModel: viewModel, themeId: $selectedThemeId)
            } else {
                NewThemeView(viewModel: viewModel, themeId: $selectedThemeId)
            }
        }
    }
    
    @ViewBuilder
    func listContent(_ theme: ThemeModel) -> some View {
        Text(theme.displayName)
            .font(.headline)
            .foregroundColor(Colors().mapColor(theme.associatedColor))
        Text(theme.emojiElements.joined(separator: " "))
            .font(.body)
        Text("Max ammount of cards: \(theme.amountOfCards)")
            .font(.footnote)
        
    }
}

#Preview {
    ThemeSelectionView(viewModel: ThemeViewModel())
}

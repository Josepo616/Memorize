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
                            ListContent(theme: themeModel)
                        }
                        .padding()
                        .contextMenu {
                            ThemeContextMenu(
                                viewModel: viewModel,
                                themeModel: themeModel,
                                isPopoverVisible: $isPopoverVisible
                            )
                        }
                    }
                }
            }
            .navigationTitle("Select a Theme")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddThemeButton(
                        viewModel: viewModel,
                        isPopoverVisible: $isPopoverVisible
                    )
                }
            }
        }
    }
}

#Preview {
    ThemeSelectionView(viewModel: ThemeViewModel())
}

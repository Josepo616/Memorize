//
//  ThemeViewModel.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

class ThemeViewModel: ObservableObject {
    @Published var themes: [ThemeModel] = []
    
    init() {
        loadThemes()
    }
    
    func loadThemes() {
        self.themes = Array(ThemeCatalog.themesByUUID.values)
    }

    func addTheme(_ theme: ThemeModel) {
        ThemeCatalog.addTheme(theme)
        themes = ThemeCatalog.allThemes()
    }
    
    func updateTheme(_ theme: ThemeModel) {
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes[index] = theme
        }
    }
    
    func getThemeById(_ id: UUID) -> ThemeModel? {
        return themes.first { $0.id == id }
    }

    func themeModel(for id: UUID) -> ThemeModel? {
        return ThemeCatalog.theme(for: id)
    }

    func displayName(for id: UUID) -> String {
        return themeModel(for: id)?.displayName ?? "Desconocido"
    }

    func description(for id: UUID) -> String {
        return themeModel(for: id)?.description ?? "Descripción no disponible"
    }

    func emojiElements(for id: UUID) -> [String] {
        return themeModel(for: id)?.emojiElements ?? []
    }

    func numberOfPairs(for id: UUID) -> Int {
        return themeModel(for: id)?.numberOfPair ?? 0
    }

    func amountOfCards(for id: UUID) -> Int {
        return themeModel(for: id)?.amountOfCards ?? 0
    }
    
    func color(for id: UUID) -> Color {
        guard let colorModel = themeModel(for: id)?.associatedColor else {
            return .black
        }
        
        return Colors().mapColor(colorModel)
    }
    
    func deleteTheme(_ id: UUID) {
        ThemeCatalog.removeTheme(with: id)
        loadThemes()
    }
}

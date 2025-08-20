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
        let colorName = themeModel(for: id)?.associatedColor ?? "black"
        return mapColor(colorName)
    }
    
    func mapColor(_ name: String) -> Color {
        let map: [String: Color] = [
            "halloween": .halloween,
            "gray": .gray,
            "animal": .animal,
            "red": .red,
            "blue": .blue,
            "yellow": .yellow,
            "black": .black,
        ]
        return map[name.lowercased(), default: .black]
    }
    
    func createTheme(named name: String) -> ThemeModel {
        return ThemeModel(
            id: UUID(),
            displayName: name.capitalized,
            associatedColor: "gray",
            description: "Tema personalizado",
            emojiElements: [],
            isRandomized: false
        )
    }
}

//
//  ThemeViewModel.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import SwiftUI

class ThemeViewModel: ObservableObject {
    @Published var themes: [ThemeModel] = []
    @Published var selectedThemeId: UUID?
    
    private let storageKey = "theme_storage"
    private let initializedFlagKey = "hasInitializedThemes"

    init() {
        loadThemes()
        //clearAllAndAllowReset()
        //resetToInitialCatalog()
    }
    
    func loadThemes() {
        let defaults = UserDefaults.standard
        
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([ThemeModel].self, from: data) {
            self.themes = decoded
            return
        }
        
        if !defaults.bool(forKey: initializedFlagKey) {
            self.themes = Array(ThemeCatalog.themesByUUID.values)
            saveThemes()
            defaults.set(true, forKey: initializedFlagKey)
        } else{
            self.themes = []
        }
    }
    
    func saveThemes() {
        if let encoded = try? JSONEncoder().encode(themes) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    func addTheme(_ theme: ThemeModel) {
        themes.append(theme)
        saveThemes()
    }

    func updateTheme(_ theme: ThemeModel) {
        if let index = themes.firstIndex(where: { $0.id == theme.id }) {
            themes[index] = theme
            saveThemes()
        }
    }

    func deleteTheme(_ id: UUID) {
        themes.removeAll { $0.id == id }
        saveThemes()
        loadThemes()
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
    
    
    
    func resetToInitialCatalog() {
        let defaults = UserDefaults.standard
        themes = Array(ThemeCatalog.themesByUUID.values)
        saveThemes()
        defaults.set(true, forKey: initializedFlagKey)
    }
    
    func clearAllAndAllowReset() {
        themes = []
        saveThemes()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: initializedFlagKey)
    }
}

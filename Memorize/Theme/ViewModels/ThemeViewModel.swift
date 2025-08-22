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
           let decoded = try? JSONDecoder().decode(
            [ThemeModel].self,
            from: data
           )
        {
            self.themes = decoded
            return
        }
        
        if !defaults.bool(forKey: initializedFlagKey) {
            self.themes = Array(ThemeCatalog.themesByUUID.values).shuffled()
            saveThemes()
            defaults.set(true, forKey: initializedFlagKey)
        } else {
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
    
    func updateTheme(_ theme: ThemeModel, _ recoverEmoji: Bool, _ newEmojiElements: [String]) {
        var updatedTheme = theme

        if let oldTheme = getThemeById(updatedTheme.id) {

            if recoverEmoji {
                updatedTheme.emojiElements = oldTheme.emojiElements + oldTheme.emojiElementsDeleted
                updatedTheme.emojiElementsDeleted = []
            } else {
                if Set(oldTheme.emojiElements) != Set(newEmojiElements) {
                    let deletedEmojiElements = oldTheme.emojiElements.filter { !newEmojiElements.contains($0) }
                    updatedTheme.emojiElements = newEmojiElements
                    updatedTheme.emojiElementsDeleted = deletedEmojiElements
                } else {
                    return
                }
            }
        } else {
            updatedTheme.emojiElements = newEmojiElements
            updatedTheme.emojiElementsDeleted = []
        }

        if let index = themes.firstIndex(where: { $0.id == updatedTheme.id }) {
            themes[index] = updatedTheme
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

    func isEmojiOnly(_ text: String) -> Bool {
        let emojiRange = "[\\p{Emoji}]"
        let regex = try! NSRegularExpression(pattern: emojiRange)
        let matches = regex.matches(
            in: text,
            range: NSRange(text.startIndex..., in: text)
        )
        return matches.count == text.count
    }

    func validationForContent(_ emojiContent: inout String, _ newValue: String)
    {
        let emojisOnly = newValue.filter { $0.isEmoji }
        emojiContent =
            emojisOnly.isEmpty ? newValue : emojisOnly.getUniqueEmoji()
    }

    func validationForAmountOfCards(
        _ amountOfCards: inout Int,
        _ newValue: Int,
        _ emojiContent: String
    ) {
        let validString = String(newValue).filter { $0.isNumber }

        if let validInt = Int(validString) {
            let maxAmount = emojiContent.count * 2

            guard validInt >= 0 else {
                amountOfCards = 0
                return
            }

            if validInt > maxAmount {
                amountOfCards = maxAmount
            } else {
                amountOfCards = validInt
            }
        }
    }

    func loadExistingTheme(
        themeId: UUID?,
        title: Binding<String>,
        emojiContent: Binding<String>,
        color: Binding<Color>,
        randomAmount: Binding<Bool>,
        amountOfCards: Binding<Int>,
        emojiDeleted: Binding<String>
    ) {
        guard let themeId = themeId,
            let existingTheme = getThemeById(themeId)
        else { return }

        title.wrappedValue = existingTheme.displayName
        emojiContent.wrappedValue = existingTheme.emojiElements.joined()
        color.wrappedValue = Color.rgb(
            red: existingTheme.associatedColor.red,
            green: existingTheme.associatedColor.green,
            blue: existingTheme.associatedColor.blue,
            alpha: existingTheme.associatedColor.alpha
        )
        randomAmount.wrappedValue = existingTheme.isRandomized
        amountOfCards.wrappedValue = existingTheme.amountOfCards ?? 4
        emojiDeleted.wrappedValue = existingTheme.emojiElementsDeleted.joined()
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

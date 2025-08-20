//
//  ThemeCatalog.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/19/25.
//

import Foundation
 

struct ThemeCatalog {
    static let halloween = ThemeModel(
        id: UUID(),
        displayName: "Halloween",
        associatedColor: "halloween",
        description: "You're playing: Halloween theme",
        emojiElements: ["🎃", "👻", "🧛‍♂️", "👽", "🧟‍♀️"],
        isRandomized: false
    )

    static let cars = ThemeModel(
        id: UUID(),
        displayName: "Cars",
        associatedColor: "gray",
        description: "You're playing: Cars theme",
        emojiElements: ["🚗", "🚙", "🚚", "🚛", "🚜", "🏎️", "🚔"],
        isRandomized: false
    )

    static let animals = ThemeModel(
        id: UUID(),
        displayName: "Animals",
        associatedColor: "animal",
        description: "You're playing: Animals theme",
        emojiElements: ["🐈", "🐫", "🐰", "🐇", "🐹", "🐻", "🐼", "🐨"],
        isRandomized: false
    )

    static let sports = ThemeModel(
        id: UUID(),
        displayName: "Sports",
        associatedColor: "red",
        description: "You're playing: Sports theme",
        emojiElements: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎱", "🏓", "⛳️", "🏆", "🤼"],
        isRandomized: true
    )

    static let flags = ThemeModel(
        id: UUID(),
        displayName: "Flags",
        associatedColor: "blue",
        description: "You're playing: Flags theme",
        emojiElements: ["🇦🇨", "🇦🇴", "🇦🇷", "🇦🇺", "🇧🇪", "🇨🇭", "🇭🇳", "🇩🇪", "🇸🇿", "🇪🇺", "🇬🇪", "🇷🇺"],
        isRandomized: true
    )

    static let food = ThemeModel(
        id: UUID(),
        displayName: "Food",
        associatedColor: "yellow",
        description: "You're playing: Food theme",
        emojiElements: ["🍗", "🥐", "🍞", "🥖", "🫓", "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗"],
        isRandomized: true
    )
    
    static var themesByUUID: [UUID: ThemeModel] = [
        ThemeCatalog.halloween.id: ThemeCatalog.halloween,
        ThemeCatalog.cars.id: ThemeCatalog.cars,
        ThemeCatalog.animals.id: ThemeCatalog.animals,
        ThemeCatalog.sports.id: ThemeCatalog.sports,
        ThemeCatalog.flags.id: ThemeCatalog.flags,
        ThemeCatalog.food.id: ThemeCatalog.food
    ]
    

    static func theme(for id: UUID) -> ThemeModel? {
        return themesByUUID[id]
    }
    
    static func allThemes() -> [ThemeModel] {
        return Array(themesByUUID.values)
    }
    
    static func addTheme(_ theme: ThemeModel) {
        themesByUUID[theme.id] = theme
    }

}

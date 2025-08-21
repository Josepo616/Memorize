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
        associatedColor: ColorModel(
            red: 1.000,
            green: 0.208,
            blue: 0.000,
            alpha: 1.0
        ),
        description: "You're playing: Halloween theme",
        emojiElements: ["🎃", "👻", "🧛‍♂️", "👽", "🧟‍♀️"],
        isRandomized: false,
        amountOfCardsChosen: 10
    )

    static let cars = ThemeModel(
        id: UUID(),
        displayName: "Cars",
        associatedColor: ColorModel(
            red: 0.557,
            green: 0.557,
            blue: 0.576,
            alpha: 1.0
        ),
        description: "You're playing: Cars theme",
        emojiElements: ["🚗", "🚙", "🚚", "🚛", "🚜", "🏎️", "🚔"],
        isRandomized: false,
        amountOfCardsChosen: 14
    )

    static let animals = ThemeModel(
        id: UUID(),
        displayName: "Animals",
        associatedColor: ColorModel(
            red: 0.802,
            green: 0.344,
            blue: 0.202,
            alpha: 1.0
        ),
        description: "You're playing: Animals theme",
        emojiElements: ["🐈", "🐫", "🐰", "🐇", "🐹", "🐻", "🐼", "🐨"],
        isRandomized: false,
        amountOfCardsChosen: 16
    )

    static let sports = ThemeModel(
        id: UUID(),
        displayName: "Sports",
        associatedColor: ColorModel(
            red: 1.000,
            green: 0.231,
            blue: 0.188,
            alpha: 1.0
        ),
        description: "You're playing: Sports theme",
        emojiElements: ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎱", "🏓", "⛳️", "🏆", "🤼"],
        isRandomized: true,
        amountOfCardsChosen: 20
    )

    static let flags = ThemeModel(
        id: UUID(),
        displayName: "Flags",
        associatedColor: ColorModel(
            red: 0.000,
            green: 0.478,
            blue: 1.000,
            alpha: 1.0
        ),
        description: "You're playing: Flags theme",
        emojiElements: [
            "🇦🇨", "🇦🇴", "🇦🇷", "🇦🇺", "🇧🇪", "🇨🇭", "🇭🇳", "🇩🇪", "🇸🇿", "🇪🇺", "🇬🇪", "🇷🇺",
        ],
        isRandomized: true,
        amountOfCardsChosen: 24
    )

    static let food = ThemeModel(
        id: UUID(),
        displayName: "Food",
        associatedColor: ColorModel(
            red: 1.000,
            green: 0.800,
            blue: 0.000,
            alpha: 1.0
        ),
        description: "You're playing: Food theme",
        emojiElements: [
            "🍗", "🥐", "🍞", "🥖", "🫓", "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗",
        ],
        isRandomized: true,
        amountOfCardsChosen:24
    )

    static var themesByUUID: [UUID: ThemeModel] = [
        ThemeCatalog.halloween.id: ThemeCatalog.halloween,
        ThemeCatalog.cars.id: ThemeCatalog.cars,
        ThemeCatalog.animals.id: ThemeCatalog.animals,
        ThemeCatalog.sports.id: ThemeCatalog.sports,
        ThemeCatalog.flags.id: ThemeCatalog.flags,
        ThemeCatalog.food.id: ThemeCatalog.food,
    ]

    static func theme(for id: UUID) -> ThemeModel? {
        print(id)

        return themesByUUID[id]
    }

    static func allThemes() -> [ThemeModel] {
        return Array(themesByUUID.values)
    }
}

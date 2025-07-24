//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/22/25.
//

import SwiftUI

//Class for the observable object - our viewModel
class EmojiMemoryGame: ObservableObject {
    //Set no theme at starting the app
    static var themes: [Theme] = [.noone]
    private(set) static var randomTheme: Theme = themes.randomElement()!
    //Get the array for cards with the random theme selected
    static var emojis = randomTheme.emojiElements
    //Func for the creation at the beginning, should start empty
    static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairOfCards: randomTheme.numberOfPair) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    //Func for mapping the colors for cards, considering theme selected
    func themeColorCards(theme: Theme) -> Color{
        let map: [String: Color] = [
            "halloween": .halloween,
            "gray": .gray,
            "animal": .animal,
            "red": .red,
            "blue": .blue,
            "yellow": .yellow,
            "black": .black
        ]
        return map[theme.colorTheme, default: .black]
    }
    //Publish the model so view can observe changes
    @Published private var model  = createMemoryGame()
    //Return the whole array of cards
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    //Create a new game with the button in the view
    func createNewGame() {
        //Add all possible themes, get a random one and get the array for pass to the emojis var
        EmojiMemoryGame.themes = [.halloween, .cars, .animals, .sports, .flags, .food]
        EmojiMemoryGame.randomTheme = EmojiMemoryGame.themes.randomElement()!
        EmojiMemoryGame.emojis = EmojiMemoryGame.randomTheme.emojiElements
        //Creation of the new game with a random theme and random amount of cards
        model = .init(numberOfPairOfCards: EmojiMemoryGame.randomTheme.numberOfPair) { pairIndex in
            if EmojiMemoryGame.emojis.indices.contains(pairIndex) {
                return EmojiMemoryGame.emojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    //Func for shuffle the array
    func shuffle() {
        model.shuffle()
    }
    //Var for score
    public var newScore = 0
    //Func for a selected card an listens for changes
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        newScore = model.newScore
    }
}

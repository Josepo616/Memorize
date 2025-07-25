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
    //Public var to be listened to in the view
    @Published var formattedTime: String = "00:00"
    //Var type Timer, and initialization of the counter of seconds
    private var timer: Timer?
    private var elapsedSeconds = 0
    //Var for track the state if the game alredy started
    private var isGameStarted = false
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
        //DispatchQueue to wait and observe changes in the model, then execute actions
        DispatchQueue.main.async {
            //Pause the timer is the game is over
            if self.model.isGameOver == true {
                self.pauseTimer()
            }
        }
        //call the func for earn points based in the time that takes the user
        if model.isGameOver == true {
            self.earnPoints()
        }
    }
    //Func for starting the timer with interval of 1, and add that second to the elapsed var, at the same time formatt the time in a string understandable
    func startTimer() {
            guard timer == nil else { return }
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds += 1
                self.formattedTime = String(format: "%02d:%02d", self.elapsedSeconds / 60, self.elapsedSeconds % 60)
            }
        }
    //Func for stop the timer
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    //Func for reset the timer, and reassing all var we used before
    func resetTimer() {
        pauseTimer()
        elapsedSeconds = 0
        formattedTime = "00:00"
    }
    //Func for the earn of point based in how much time the user takes
    func earnPoints() {
    switch elapsedSeconds {
        case 0..<10: newScore += 30; break
        case 10..<20: newScore += 20; break
        case 20..<30: newScore += 10; break
        case 30..<40: newScore += 5; break
        case 40..<50: newScore += 2; break
        case 50..<60: newScore += 1; break
        case 60..<70: newScore -= 1; break
        case 70..<80: newScore -= 2; break
        case 80..<90: newScore -= 5; break
        case 90..<100 :newScore -= 10; break
        case 100..<110: newScore -= 20; break
        case 110..<120: newScore -= 30; break
        default: break
        }
    }
}

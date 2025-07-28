//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/22/25.
//
import SwiftUI
/// ViewModel for the Emoji Memory Game.
///
/// This class serves as the bridge between the view (`EmojiMemoryGameView`) and the game model (`MemoryGame`).
/// It manages the game's theme, score, timing logic, and user interactions, and notifies the UI of changes.
///
/// - Conforms to: `ObservableObject`
/// - Publishes:
///   - `formattedTime`: Formatted string of the elapsed game time.
///   - Internal model updates via `@Published` game state.

class EmojiMemoryGame: ObservableObject {
    @Published var formattedTime: String = "00:00"
    @Published private var model  = createMemoryGame()
    private(set) static var randomTheme: Theme = themes.randomElement()!
    private var timer: Timer?
    private var elapsedSeconds = 0
    private var isGameStarted = false
    public var newScore = 0
    static var themes: [Theme] = [.empty]
    static var emojis = randomTheme.emojiElements.shuffled()
    var cards: [MemoryGame<String>.Card] {
        return model.cards
    }
    
    static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairOfCards: randomTheme.numberOfPair) { pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    
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
    
    func createNewGame() {
        EmojiMemoryGame.themes = [.halloween, .cars, .animals, .sports, .flags, .food]
        EmojiMemoryGame.randomTheme = EmojiMemoryGame.themes.randomElement()!
        EmojiMemoryGame.emojis = EmojiMemoryGame.randomTheme.emojiElements
        model = .init(numberOfPairOfCards: EmojiMemoryGame.randomTheme.numberOfPair) { pairIndex in
            if EmojiMemoryGame.emojis.indices.contains(pairIndex) {
                return EmojiMemoryGame.emojis[pairIndex]
            } else {
                return "!?"
            }
        }
    }
    
    func shuffle() {
        model.shuffle()
    }
    // MARK: - Card Selection
    /// Handles the logic when a card is selected by the user.
    ///
    /// - Parameter card: The card that was tapped.
    ///
    /// Updates the score, checks for game end, and interacts with the timer.
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        newScore = model.newScore
        DispatchQueue.main.async {
            if self.model.isGameOver == true {
                self.pauseTimer()
            }
        }
        if model.isGameOver == true {
            self.earnPoints()
        }
    }
    // MARK: - Timer Management
    /// Starts the game timer if not already running.
    ///
    /// Increments `elapsedSeconds` every second and updates the formatted time string.
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.elapsedSeconds += 1
            self.formattedTime = String(format: "%02d:%02d", self.elapsedSeconds / 60, self.elapsedSeconds % 60)
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimerAndScore() {
        pauseTimer()
        elapsedSeconds = 0
        formattedTime = "00:00"
        newScore = 0
    }
    // MARK: - Scoring Logic
    /// Adjusts the score based on how quickly the game was completed.
    ///
    /// Rewards fast completion with more points and penalizes slower times.
    
    func earnPoints() {
        switch elapsedSeconds {
        case 0..<10:
            newScore += 30;
            break
        case 10..<20:
            newScore += 20;
            break
        case 20..<30:
            newScore += 10;
            break
        case 30..<40:
            newScore += 5;
            break
        case 40..<50:
            newScore += 2;
            break
        case 50..<60:
            newScore += 1;
            break
        case 60..<70:
            newScore -= 1;
            break
        case 70..<80:
            newScore -= 2;
            break
        case 80..<90:
            newScore -= 5;
            break
        case 90..<100 :
            newScore -= 10;
            break
        case 100..<110:
            newScore -= 20;
            break
        case 110..<120:
            newScore -= 30;
            break
        default:
            break
        }
    }
}

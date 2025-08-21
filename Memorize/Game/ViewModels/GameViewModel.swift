//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/22/25.
//
import SwiftUI

class GameViewModel: ObservableObject {
    @Published var formattedTime: String = "00:00"
    @Published private var model: MemoryGame<String>?
    private var themeId: UUID
    private unowned let themeViewModel: ThemeViewModel
    
    private var timer: Timer?
    private var elapsedSeconds = 0
    private var isGameStarted = false
    public var newScore = 0


    var cards: [GameModel<String>] {
        return model?.cards ?? []
    }
    
    init(themeViewModel: ThemeViewModel, themeID: UUID) {
        guard themeViewModel.themeModel(for: themeID) != nil else {
            fatalError("Theme with ID \(themeID) not found. Check your ThemeCatalog.")
        }
        self.themeViewModel = themeViewModel
        self.themeId = themeID
        createNewGame()
        
    }
    
    var theme: ThemeModel? {
        themeViewModel.getThemeById(themeId)
    }
    
    static func createMemoryGame(with theme: ThemeModel) -> MemoryGame<String> {
        return MemoryGame(numberOfPairOfCards: theme.numberOfPair) { pairIndex in
            theme.emojiElements.indices.contains(pairIndex) ? theme.emojiElements[pairIndex] : "!?"
        }
    }
    
    func color() -> Color {
        guard theme != nil else { return .black }        
        return Colors().mapColor(theme!.associatedColor)
    }
    
    func createNewGame() {
        guard let themes = theme else { return }
        
        self.model = GameViewModel.createMemoryGame(with: themes)
        self.newScore = 0
        self.elapsedSeconds = 0
    }

    func shuffle() {
        model?.shuffle()
    }
    // MARK: - Card Selection
    /// Handles the logic when a card is selected by the user.
    /// Updates the score, checks for game end, and interacts with the timer.
    
    func choose(_ card: GameModel<String>) {
        model?.choose(card)
        newScore = model?.newScore ?? 0
        if model?.isGameOver == true {
            pauseTimer()
            earnPoints()
        }
    }
    // MARK: - Timer Management
    /// Starts the game timer if not already running.
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

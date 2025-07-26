//
//  MemorizeGame.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/22/25.
//
import Foundation
/// A generic memory game model where the content of the cards can be any `Equatable` type.
///
/// This struct manages the state and logic of a memory card-matching game, including card flipping,
/// score tracking, and game over detection.
///
/// - Type Parameters:
///   - CardContent: The type of content shown on the cards. Must conform to `Equatable`.
struct MemoryGame<CardContent> where CardContent: Equatable{
    private(set) var cards: Array<Card>
    var newScore = 0
    var isGameOver = false
    var indexOfTheOnlyFaceUpCard: Int?{
        get { return cards.indices.filter{index in cards[index].isFaceUp}.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    // MARK: - Initialization
    /// Creates a new memory game with a given number of card pairs and a content factory.
    ///
    /// - Parameters:
    ///   - numberOfPairOfCards: The number of card pairs in the game (minimum of 2 enforced).
    ///   - cardContentFactory: A closure that provides the content for each card pair based on its index.
    ///
    /// For each pair, two cards with identical content but unique IDs are created.
    init(numberOfPairOfCards: Int, cardContentFactory: (Int) -> CardContent){
        cards = []
        if(numberOfPairOfCards > 0){
            for pairIndex in 0..<max(2, numberOfPairOfCards){
                let content = cardContentFactory(pairIndex)
                cards.append(Card(content: content, id: "\(pairIndex+1)a"))
                cards.append(Card(content: content, id: "\(pairIndex+1)b"))
            }
        }
    }
    mutating func shuffle() {
        cards.shuffle()
    }
    /// function that works with the actual card selected
    ///// Handles the logic when a card is selected by the user.
    ///
    /// - Parameters:
    ///   - card: The card that was tapped.
    ///
    /// This function:
    /// - Finds the selected card by ID.
    /// - Ignores the selection if the card is already face up or matched.
    /// - If there is another card already face up, it checks for a match:
    ///   - If they match, marks both as matched.
    ///   - Updates the score based on match status and whether cards were seen before.
    /// - Marks the selected cards as previously seen.
    /// - If no other card is face up, it sets the current one as the only face-up card.
    /// - Ends the game if all cards are matched.
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }){
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched{
                if let potentialMatchIndex = indexOfTheOnlyFaceUpCard{
                    if cards[potentialMatchIndex].content == cards[chosenIndex].content{
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                    updateEarnScore(isMatched: cards[potentialMatchIndex].isMatched, choosePreviousSeen: cards[chosenIndex].previouslySeen, potencialChoosePreviousSeen: cards[potentialMatchIndex].previouslySeen)
                    cards[chosenIndex].previouslySeen = true
                    cards[potentialMatchIndex].previouslySeen = true
                } else {
                    indexOfTheOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
        if cards.allSatisfy(\.isMatched) {
            isGameOver = true
        }
    }
    private mutating func updateEarnScore(isMatched: Bool, choosePreviousSeen: Bool, potencialChoosePreviousSeen: Bool) {
        self.newScore += isMatched ? 2 : (choosePreviousSeen || potencialChoosePreviousSeen ? -1 : 0)
    }
    struct Card: Equatable, Identifiable{
        var isFaceUp = false
        var isMatched = false
        var previouslySeen = false
        let content: CardContent
        var id: String
    }
}
/// Represents the available themes for the memory game.
///
/// Each theme defines:
/// - A set of emojis (`emojiElements`) specific to the theme.
/// - A color identifier (`colorTheme`) used for styling.
/// - A user-friendly description (`description`).
/// - A logic for determining the number of pairs (`numberOfPair`).
enum Theme {
    case halloween
    case cars
    case animals
    case sports
    case flags
    case food
    case noone
    // MARK: - Theme Color
    /// The color name associated with the theme, used for UI styling.
    var colorTheme: String{
     switch self {
        case .halloween: return "halloween"
        case .cars:  return "gray"
        case .animals: return "animal"
        case .sports: return "red"
        case .flags: return "blue"
        case .food: return "yellow"
        case .noone: return "black"
        }
    }
    // MARK: - Description
    /// A user-friendly string describing the current theme.
    var description: String {
        switch self {
        case .halloween: return "Your're playing: Halloween theme"
        case .cars: return "Your're playing: Cars theme"
        case .animals: return "You're playing: Animals theme"
        case .sports: return "You're playing: Sports theme"
        case .flags: return "You're playing: Flags theme"
        case .food: return "You're playing: Food theme"
        case .noone: return "You're not playing a theme"
        }
    }
    // MARK: - Emoji Content
    /// A shuffled array of emoji strings associated with the theme.
    var emojiElements: [String] {
        var emojiElementsShuffled: [String]
        switch self {
        case .halloween: emojiElementsShuffled = ["🎃", "👻", "🧛‍♂️", "👽", "🧟‍♀️"]
        case .cars: emojiElementsShuffled =  ["🚗", "🚙" , "🚚", "🚛", "🚜", "🏎️", "🚔"]
        case .animals: emojiElementsShuffled =  ["🐈", "🐫", "🐰", "🐇", "🐹", "🐻", "🐼", "🐨"]
        case .sports: emojiElementsShuffled = ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎱", "🏓", "⛳️", "🏆", "🤼"]
        case .flags: emojiElementsShuffled = ["🇦🇨", "🇦🇴", "🇦🇷", "🇦🇺", "🇧🇪", "🇨🇭", "🇭🇳", "🇩🇪", "🇸🇿", "🇪🇺", "🇬🇪", "🇷🇺"]
        case .food: emojiElementsShuffled = ["🍗", "🥐", "🍞", "🥖", "🫓", "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗"]
        case .noone: emojiElementsShuffled =  []
        }
        return emojiElementsShuffled.shuffled()
    }
    // MARK: - Game Logic
    /// The number of emoji pairs to be used in the game for the selected theme.
    ///
    /// Some themes return all available emojis, while others (like `cars`, `sports`, or `flags`) return a random count.
    var numberOfPair: Int {
        switch self {
        case .halloween: return emojiElements.count
        case .cars: return Int.random(in: 1...emojiElements.count)
        case .animals: return emojiElements.count
        case .sports: return Int.random(in: 1...emojiElements.count)
        case .flags: return Int.random(in: 1...emojiElements.count)
        case .food: return emojiElements.count
        case .noone: return 0
        }
    }
}
extension Array{
    var only: Element? {
         count == 1 ? first : nil
    }
}

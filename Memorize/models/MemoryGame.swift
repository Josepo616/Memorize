//
//  MemorizeGame.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/22/25.
//

import Foundation
//Main struct for our game and changes on it
struct MemoryGame<CardContent> where CardContent: Equatable{
    //Var for score
    var newScore = 0
    //Var for track if the game over
    var isGameOver = false
    //Initialization of the game, empty at the beginning; actual game should be created using the button in the UI
    private(set) var cards: Array<Card>
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
    //Get the index of the current face up card
    var indexOfTheOnlyFaceUpCard: Int?{
        get { return cards.indices.filter{index in cards[index].isFaceUp}.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    //Shuffle the array of cards
    mutating func shuffle() {
        cards.shuffle()
    }
    //Compare the first two face up cards, if they are equal mark the bools true and update the score
    mutating func choose(_ card: Card){
        //Search the index of the selected card
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }){
            //Verify the card is not flipped or paired
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched{
                //Check if there is a single card face up (potential pair)
                if let potentialMatchIndex = indexOfTheOnlyFaceUpCard{
                    //Compare the contents to see if there is a match
                    if cards[potentialMatchIndex].content == cards[chosenIndex].content{
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                    //Call the func to update the score, considering all posibilities like previous seen for rest, or there is a match for sum
                    updateEarnScore(isMatched: cards[potentialMatchIndex].isMatched, choosePreviousSeen: cards[chosenIndex].previouslySeen, potencialChoosePreviousSeen: cards[potentialMatchIndex].previouslySeen)
                    //Updated or not, mark both as previous seen
                    cards[chosenIndex].previouslySeen = true
                    cards[potentialMatchIndex].previouslySeen = true
                } else {
                    indexOfTheOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
        }
        //Special func to check is the array and all his indexes meets a specific condition
        if cards.allSatisfy(\.isMatched) {
            isGameOver = true
        }
    }
    //Func for updating the score
    private mutating func updateEarnScore(isMatched: Bool, choosePreviousSeen: Bool, potencialChoosePreviousSeen: Bool) {
        self.newScore += isMatched ? 2 : (choosePreviousSeen || potencialChoosePreviousSeen ? -1 : 0)
    }
    //Main struct for cards,
    struct Card: Equatable, Identifiable{
        var isFaceUp = false
        var isMatched = false
        var previouslySeen = false
        let content: CardContent
        var id: String
    }
}

//We create a enum data type for the array of emojis, the theme of the cards, descriptions/label Title and the number of pairs
enum Theme {
    case halloween
    case cars
    case animals
    case sports
    case flags
    case food
    case noone
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
//Returns the single element if the array has exactly one; otherwise, nil
extension Array{
    var only: Element? {
         count == 1 ? first : nil
    }
}

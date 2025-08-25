//
//  MemorizeGame.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/22/25.
//
import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {

    private(set) var cards: [GameModel<CardContent>]
    var newScore = 0
    var isGameOver = false
    var indexOfTheOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { index in cards[index].isFaceUp }.only
        }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }

    init(numberOfPairOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        if numberOfPairOfCards > 0 {
            for pairIndex in 0..<max(2, numberOfPairOfCards) {
                let content = cardContentFactory(pairIndex)
                cards.append(GameModel(content: content, id: "\(pairIndex+1)a"))
                cards.append(GameModel(content: content, id: "\(pairIndex+1)b"))
            }
            shuffle()
        }
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    mutating func choose(_ card: GameModel<CardContent>) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOnlyFaceUpCard {
                    if cards[potentialMatchIndex].content
                        == cards[chosenIndex].content
                    {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                    updateEarnScore(
                        isMatched: cards[potentialMatchIndex].isMatched,
                        choosePreviousSeen: cards[chosenIndex].previouslySeen,
                        potencialChoosePreviousSeen: cards[potentialMatchIndex]
                            .previouslySeen
                    )
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

    private mutating func updateEarnScore(
        isMatched: Bool,
        choosePreviousSeen: Bool,
        potencialChoosePreviousSeen: Bool
    ) {
        self.newScore +=
            isMatched
            ? 2 : (choosePreviousSeen || potencialChoosePreviousSeen ? -1 : 0)
    }
}

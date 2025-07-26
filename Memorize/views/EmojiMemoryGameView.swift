//
//  ContentView.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/14/25.
//

import SwiftUI
/// Main view for the Emoji Memory Game.
///
/// This view acts as the primary UI for displaying the game interface, including the current theme, grid of cards, score, timer, and control buttons.
///
/// - Properties:
///   - viewModel: The `EmojiMemoryGame` observable object that manages the game's state and logic.
///
/// - Subviews:
///   - cards: A computed property that renders a grid of cards using `LazyVGrid`, where each card responds to tap gestures.
///
/// - Body:
///   - Displays the current theme title in a `HStack`.
///   - Shows the game grid inside a `ScrollView`, styled with the theme's color.
///   - Below the grid, the current timer and score are displayed.
///   - A "New Game" button resets the game, shuffles the cards, and restarts the timer.
///
/// - Notes:
///   - Card tap gestures trigger selection via `viewModel.choose(card)` and start the timer.
///   - Animations are applied smoothly when cards update.
struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    var body: some View {
        HStack{
            Text("\(EmojiMemoryGame.randomTheme.description)")
                .font(.title)
        }
        VStack{
            ScrollView{
                cards
                    .animation(.smooth(duration: 0.5), value: viewModel.cards)
            }
            .foregroundColor(viewModel.themeColorCards(theme: EmojiMemoryGame.randomTheme))
            Spacer()
            Text(viewModel.formattedTime)
            Text("Your current score is: \(viewModel.newScore)")
            Spacer()
            Button("New Game") {
                viewModel.createNewGame()
                viewModel.shuffle()
                viewModel.resetTimer()
            }
        }
        .imageScale(.small)
        .padding()
    }
    var cards: some View {
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 0)], spacing: 0){
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                        viewModel.startTimer()
                    }
            }
        }
    }
}
/// Main struct of the cards displayed in the memory game.
///
/// This view is responsible for rendering each individual card
/// with its content and visual appearance based on the card state (face up, face down, or matched).
///
/// - Variables:
///   - card: The individual card provided by the `MemoryGame` model. It contains the content (e.g., a string) and state (face up, matched).
///
/// - Constants:
///   - base: A rounded rectangle shape used as the card's background and border.
///
/// - Returns: A view that renders the card using a ZStack. The content is shown if the card is face up; otherwise, a filled background is shown.
///            If the card is matched and face down, it becomes fully transparent.
struct CardView: View {
    let card: MemoryGame<String>.Card
    let base = RoundedRectangle(cornerRadius: 12)
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    var body: some View {
        ZStack(alignment: .center){
            Group{
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.1)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}
#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}

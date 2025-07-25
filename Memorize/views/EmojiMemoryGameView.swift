//
//  ContentView.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/14/25.
//

import SwiftUI

//Main struct
struct EmojiMemoryGameView: View {
    //Definition of observed object for viewModel
    @ObservedObject var viewModel: EmojiMemoryGame

    //Main view where we call all views of func we need
    var body: some View {
        //HStack for titles
        HStack{
            Text("\(EmojiMemoryGame.randomTheme.description)")
                .font(.title)
        }
        //VStack for all cards to play
        VStack{
            ScrollView{
                cards
                    .animation(.smooth(duration: 0.5), value: viewModel.cards)
            }
            .foregroundColor(viewModel.themeColorCards(theme: EmojiMemoryGame.randomTheme))
            Spacer()
            //Score description and button for start new games
            Text("Your current score is: \(viewModel.newScore)")
            Spacer()
            Button("New Game") {
                viewModel.createNewGame()
                viewModel.shuffle()
            }
        }
        .imageScale(.small)
        .padding()
    }
    //View for the generation of all cards
    var cards: some View {
        //Lazy grid for adaptation
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 0)], spacing: 0){
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
    }
}
//Struct for cards
struct CardView: View {
    //initialize the CardView with a specifict MemoryGame card
    let card: MemoryGame<String>.Card
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    //View for the creation of a specific card
    var body: some View {
        ZStack(alignment: .center){
            let base = RoundedRectangle(cornerRadius: 12)
            Group{
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.1)
                    .aspectRatio(1, contentMode: .fit)
            }
            //Change the opacity if face up or not
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        //Change the opacity when 2 match
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}

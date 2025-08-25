//
//  ContentView.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/14/25.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel: GameViewModel
    let theme: ThemeModel
    let themeViewModel: ThemeViewModel
    
    init(theme: ThemeModel, themeViewModel: ThemeViewModel) {
        self.theme = theme
        self.themeViewModel = themeViewModel
        _viewModel = StateObject(wrappedValue: GameViewModel(themeViewModel: themeViewModel, themeID: theme.id))
    }

    var body: some View {
        VStack {
            Text(viewModel.theme!.description)
            ScrollView {
                cards
                    .animation(.smooth(duration: 0.5), value: viewModel.cards)
            }
            .foregroundColor(viewModel.color())
            Spacer()
            Text(viewModel.formattedTime)
            Text("Your current score is: \(viewModel.newScore)")
            Spacer()
            Button("New Game") {
                viewModel.createNewGame()
                viewModel.shuffle()
                viewModel.resetTimerAndScore()
            }
        }
        .padding()
    }

    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 0)], spacing: 0) {
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

/*
#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}*/

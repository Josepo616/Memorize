//
//  ContentView.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/14/25.
//

import SwiftUI

//Main struc where call all other func views we need
struct EmojiMemoryGameView: View {
    @State var emojis =  emojisCollections(theme: .noone)
    @State var maxCard = 0
    @State var themeColorCard = themeColorCards(theme: .noone)
    //Main view where we call all views of func we need
    var body: some View {
        VStack{
            Text("Memorize!")
                .font(.largeTitle)
        }
        VStack{
            ScrollView{
                cards
            }
            Spacer()
            themeAdjusters
                .imageScale(.large)
                .font(.largeTitle)
            }
        .foregroundColor(themeColorCard)
        .imageScale(.small)
        .padding()
    }
    //View for all theme's someone can choose
    var themeAdjusters: some View {
        HStack {
            hallowenTheme
            carsTheme
            animalsTheme
        }
    }
    //View for the automatized generations of cards
    var cards: some View {
        //Generating a copy of array emojis but now shuffled
        let randomEmojis: [String] = generateRandomEmojis(numberOfAllCards: numberOfAllCards)
        let randomEmojisShuffled = randomEmojis.shuffled()
        //iterating over all items or index of the array shuffled
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]){
            ForEach(0..<randomEmojisShuffled.count, id: \.self) { index in
                CardView(content: randomEmojisShuffled[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
    //Getting a random number between 8 (we ensure at least 4 pairs) and the maximium index count of any array we pass
    var numberOfAllCards: Int {
        guard emojis.count >= 8 else {return 0}
        let numberRandom = Int.random(in: 8..<emojis.count)
        return numberRandom.isMultiple(of: 2) ? numberRandom : numberRandom + 1
    }
    //func where we pass the random number of cards, then make a "coppy" but with property prefix that help us to get the same array but limited starting on 0 to the max index we decided
    func generateRandomEmojis(numberOfAllCards: Int) -> [String] {
        return Array(emojis.prefix(numberOfAllCards))
    }
    //Func to generate buttons and change the themes card, now using an enum, you only need to pass a variable of type Theme and then access its properties.
    func themeAdjustment(for theme: Theme) -> some View{
        Button(action:{
            emojis = emojisCollections(theme: theme)
            themeColorCard = themeColorCards(theme: theme)
        }, label:{
            VStack{
                Image(systemName: theme.symbol)
                    .foregroundStyle(.myIcon)
                Text(theme.description)
                    .font(.caption)
                    .foregroundColor(.myTextDescription)
            }
        })
        .padding(10)
    }
    //Views of the 3 different themes
    var hallowenTheme : some View {
        themeAdjustment(for: .halloween)
    }
    var carsTheme: some View {
        themeAdjustment(for: .cars)
    }
    var animalsTheme: some View{
        themeAdjustment(for: .animals)
    }
}
//Struct for cards and the state of isFaceU
struct CardView: View {
    let content: String
    @State var isFaceUp = false
    //View of cards with the rectangle fill or not, an funcionality of tap a card
    var body: some View {
        ZStack(alignment: .center){
            let base = RoundedRectangle(cornerRadius: 12)
            Group{
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture(perform:  {
            isFaceUp.toggle()
        })
    }
}
//Adding theme emojis and colors array, now we select the array or colorCard by enums
func emojisCollections(theme: Theme) -> [String]{
    var emojis : [String] = [""]
    switch theme{
    case .halloween:
        emojis =  ["👻", "👻", "👽", "👽", "👾", "👾", "👿", "👿", "💀", "💀"]
        break
    case .cars:
        emojis =  ["🚗", "🚗", "🚙", "🚙", "🚚", "🚚", "🚛", "🚛", "🚜", "🚜", "🏎️", "🏎️", "🚔", "🚔"]
        break
    case .animals:
        emojis = ["🐈", "🐈", "🐫", "🐫", "🐰", "🐰", "🐇", "🐇", "🐹", "🐹", "🐻", "🐻", "🐼", "🐼", "🐨", "🐨"]
        break
    case .noone:
        emojis = []
        break
    }
    return emojis
}
func themeColorCards(theme: Theme) -> Color{
    var colorTheme: Color
    switch theme{
    case .halloween:
        colorTheme = .halloween
        break
    case .cars:
        colorTheme = .gray
        break
    case .animals:
        colorTheme = .animal
        break
    case .noone:
        colorTheme = .black
        break
    }
    return colorTheme
}
//We create a enum data type for the array of emojis, the theme of the cards, descriptions/label for buttons and the icon
enum Theme {
    case halloween
    case cars
    case animals
    case noone
    
    var description: String {
        switch self {
        case .halloween: return "Halloween"
        case .cars: return "Cars"
        case .animals: return "Animals"
        case .noone: return "No theme"
        }
    }

    var symbol: String {
        switch self {
        case .halloween: return "ev.plug.dc.chademo"
        case .cars: return "car.rear"
        case .animals: return "pawprint.circle"
        case .noone: return "questionmark"
        }
    }
}

#Preview {
    EmojiMemoryGameView()
}

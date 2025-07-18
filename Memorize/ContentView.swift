//
//  ContentView.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/14/25.
//

import SwiftUI

//Main struc where call all other func views we need
struct ContentView: View {
    @State var emojis =  emojisCollections(theme: "")
    @State var maxCard = 0
    @State var themeColorCard = themeColorCards(theme: "")
    
    let maxWidth: Double = UIScreen.main.bounds.width
    let maxHeight: Double = UIScreen.main.bounds.height

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
        
        //Getting a random number between 8 (we ensure at least 4 pairs) and the maximium index count of any array we pass
        var numberOfAllCards: Int {
            if emojis.count >= 8 {
                var numberRandom = Int.random(in: 8..<emojis.count)
                
                //if number is odd, we plus 1 for make it even
                if numberRandom % 2 != 0 {
                    numberRandom += 1
                }
                return numberRandom
            }
            return 0
        }

        //func where we pass the random number of cards, then make a "coppy" but with property prefix that help us to get the same array but limited starting on 0 to the max index we decided
        func generateRandomEmojis(numberOfAllCards: Int) -> [String] {
            let limitedEmojis = emojis.prefix(numberOfAllCards)
            if(limitedEmojis != []){
                return Array(limitedEmojis)
            }
            return []
        }
        
        
        //Generating a copy of array emojis but now shuffled
        @State var randomEmojis: [String] = generateRandomEmojis(numberOfAllCards: numberOfAllCards)
        @State var randomEmojisShuffled = randomEmojis.shuffled()

        
        
        //iterating over all items or index of the array shuffled
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]){
            ForEach(0..<randomEmojisShuffled.count, id: \.self) { index in
                CardView(content: randomEmojisShuffled[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        
        /*
        func getTheBestMinSize(numberOfAllCards: CGFloat) -> CGFloat {
            var minSize: CGFloat = 0
            
            switch numberOfAllCards {
            case 8:
                minSize  =  105
            case 10:
                minSize  =  100
            case 11...20:
                minSize  =  96
            default:
                minSize  =  50
                break
            }
            print("min size: \(minSize)")
            print("number of cards: \(numberOfAllCards)")
            return minSize
        }
        
        func getTheBestMaxSize(numberOfAllCards: CGFloat) -> CGFloat {
            var maxSize: CGFloat = 0

            switch numberOfAllCards {
            case 8:
                maxSize  =  105
            case 10:
                maxSize  =  90
            case 11...20:
                maxSize  =  96
            default:
                maxSize  =  50
                break
            }

            return maxSize
        }
         */
        
    }

    //Func to generate buttons and change the themes card
    func themeAdjustment(by offset: String, symbol: String, description: String) -> some View{
        Button(action:{
            emojis = emojisCollections(theme: offset)
            themeColorCard = themeColorCards(theme: offset)
            
        }, label:{
            VStack{
                Image(systemName: symbol)
                    .foregroundStyle(.myIcon)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.myTextDescription)
            }
        })
        .padding(10)
    }
    //Views of the 3 different themes
    var hallowenTheme : some View {
        themeAdjustment(by: "Hallowen", symbol: "ev.plug.dc.chademo", description: "Hallowen")
    }
    var carsTheme: some View {
        themeAdjustment(by: "Cars", symbol: "car.rear", description: "Cars")
    }
    var animalsTheme: some View{
        themeAdjustment(by: "Animals", symbol: "pawprint.circle", description: "Animals")
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

//Adding theme emojis arrays
func emojisCollections(theme: String) -> [String]{
    var emojis : [String] = [""]
    switch theme{
    case "Hallowen":
        emojis =  ["👻", "👻", "👽", "👽", "👾", "👾", "👿", "👿", "💀", "💀"]
        break
    case "Cars":
        emojis =  ["🚗", "🚗", "🚙", "🚙", "🚚", "🚚", "🚛", "🚛", "🚜", "🚜", "🏎️", "🏎️", "🚔", "🚔"]
        break
    case "Animals":
        emojis = ["🐈", "🐈", "🐫", "🐫", "🐰", "🐰", "🐇", "🐇", "🐹", "🐹", "🐻", "🐻", "🐼", "🐼", "🐨", "🐨"]
    default:
        emojis = []
        break
    }
    return emojis
}

func themeColorCards(theme: String) -> Color{
    var colorTheme: Color
    switch theme{
    case "Hallowen":
        colorTheme = .hallowen
        break
    case "Cars":
        colorTheme = .gray
        break
    case "Animals":
        colorTheme = .animal
    default:
        colorTheme = .black
        break
    }
    return colorTheme
}



#Preview {
    ContentView()
}

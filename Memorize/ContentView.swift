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
        .foregroundColor(.myCard)
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
        @State var randomEmojis = emojis.shuffled()
        //iterating over all items or index of the array shuffled
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]){
            ForEach(00..<emojis.endIndex, id: \.self){ index in
                CardView(content: randomEmojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }

    //Func to generate buttons and change the themes card
    func themeAdjustment(by offset: String, symbol: String, description: String, ) -> some View{
        Button(action:{
            emojis = emojisCollections(theme: offset)
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



#Preview {
    ContentView()
}

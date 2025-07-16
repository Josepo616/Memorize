//
//  ContentView.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/14/25.
//

import SwiftUI

struct ContentView: View {
    @State var emojis =  emojisCollections(theme: "Hallowen")
    @State var maxCard = 0


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
        .foregroundColor(.red)
        .imageScale(.small)
        .padding()
    }
    
    var themeAdjusters: some View {
        HStack {
            hallowenTheme
            carsTheme
            animalsTheme
        }
    }
    
    var cards: some View {
        @State var randomEmojis = emojis.shuffled()
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]){
            ForEach(00..<emojis.endIndex, id: \.self){ index in
                CardView(content: randomEmojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
    }
    
    func getMaxEmojisCount(emojis: [String]) -> Int{
        emojis.count
    }
    
    func cardCounterAdjusters(by offset: Int, symbol: String) -> some View{
        Button(action:{
            maxCard += offset
        }, label:{
            Image(systemName: symbol)
        })
        .disabled(maxCard + offset < 1 || maxCard + offset > emojis.count)
    }
    var cardRemover : some View {
        cardCounterAdjusters(by: -1, symbol: "rectangle.stack.badge.minus.fill")
    }
    var cardAdder : some View {
        cardCounterAdjusters(by: +1, symbol: "rectangle.stack.badge.plus.fill")
    }
    
    func themeAdjustment(by offset: String, symbol: String, description: String) -> some View{
        Button(action:{
            emojis = emojisCollections(theme: offset)
        }, label:{
            VStack{
                Image(systemName: symbol)
                    .foregroundStyle(.tint)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.myTextDescription)
            }
        })
        .padding(10)
    }
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
 
struct CardView: View {
    let content: String
    @State var isFaceUp = false
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

//Adding new features

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
        emojis = [""]
        break
    }
    return emojis
}



#Preview {
    ContentView()
}

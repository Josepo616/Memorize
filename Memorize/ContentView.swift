//
//  ContentView.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
            VStack{
                HStack{
                CardView(isFaceUp: true)
                CardView()
                CardView()
            }
        }
        .font(.largeTitle)
        .foregroundColor(.blue)
        .imageScale(.small)
        .padding()
    }
}


struct CardView: View {
    var isFaceUp = false
    var body: some View {
        ZStack(alignment: .top){
            let base = RoundedRectangle(cornerRadius: 12)

            if(isFaceUp){
                base
                    .foregroundColor(.white)
                base
                    .strokeBorder(lineWidth: 2)
                Text("🗿")
            }else{
                base
            }
        }
    }
}


#Preview {
    ContentView()
}

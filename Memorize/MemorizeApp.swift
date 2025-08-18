//
//  MemorizeApp.swift
//  Memorize
//
//  Created by JoseAlvarez on 7/15/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
            
        }
    }
}

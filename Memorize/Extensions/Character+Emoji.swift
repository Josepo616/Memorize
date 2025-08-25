//
//  String+Emoji.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/20/25.
//

import Foundation

extension Character {
    
    var isEmoji: Bool {
        guard let scalar = self.unicodeScalars.first else { return false }
        
        if scalar.value >= 0x30 && scalar.value <= 0x39 {
            return false
        }
        
        return scalar.properties.isEmoji
    }
}

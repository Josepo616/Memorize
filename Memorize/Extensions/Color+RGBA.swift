//
//  Color+RGBA.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/25/25.
//

import SwiftUI

extension RGBAColor {
    
    var swiftUIColor: Color {
        return Color.rgb(red: CGFloat(self.red), green: CGFloat(self.green), blue: CGFloat(self.blue), alpha: CGFloat(self.alpha))
    }
}


//
//  Color+RGB.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/20/25.
//

import SwiftUI

extension Color {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> Color {
        return Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    func getRGBComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

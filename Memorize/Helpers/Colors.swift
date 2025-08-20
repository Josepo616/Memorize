//
//  Colors.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/20/25.
//

import SwiftUI

struct Colors {
    func mapColor(_ colorModel: ColorModel) -> Color {
        return Color.rgb(red: CGFloat(colorModel.red), green: CGFloat(colorModel.green), blue: CGFloat(colorModel.blue), alpha: CGFloat(colorModel.alpha))
    }
}


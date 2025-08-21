//
//  ColorSection.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import SwiftUI

struct ColorSection: View {
    @Binding var color: Color

    var body: some View {
        Section(header: Text("Theme Color")) {
            ColorPicker("Choose a color", selection: $color)
        }
    }
}

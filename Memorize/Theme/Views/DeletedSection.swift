//
//  DeletedSection.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/22/25.
//

import SwiftUI

struct DeletedSection: View {
    @Binding var showDeleted: Bool
    
    var body: some View {
        Section(header: Text("Emojis Deleted")) {
            Toggle("Enable to see deleted emojis", isOn: $showDeleted)
        }
    }
}

//
//  String+Number.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import Foundation

extension String {
    
    func onlyNumbers() -> String {
        return self.filter { $0.isNumber }
    }
}

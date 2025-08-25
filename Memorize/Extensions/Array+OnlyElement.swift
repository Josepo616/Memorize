//
//  Array+OnlyElement.swift
//  Memorize
//
//  Created by JoseAlvarez on 8/21/25.
//

import Foundation

extension Array {

    var only: Element? {
        count == 1 ? first : nil
    }
}

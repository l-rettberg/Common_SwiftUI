//
//  IdentifiableCharacter.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/05/2024.
//

import Foundation

internal struct IdentifiableCharacter: Identifiable {
    var id: String { "\(index) \(character)" }

    let index: Int
    let character: Character
}

extension IdentifiableCharacter {
    var string: String { "\(character)" }
}

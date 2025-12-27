//
//  Array+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/05/2024.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

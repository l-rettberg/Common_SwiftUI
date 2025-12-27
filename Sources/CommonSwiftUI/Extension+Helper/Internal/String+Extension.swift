//
//  String+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 30/05/2024.
//

import Foundation

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

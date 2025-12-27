//
//  Neumorphism.swift
//  CommonSwiftUI
//
//  Created by James Thang on 18/06/2024.
//

import SwiftUI

struct Neumorphism: ViewModifier {
    
    var color: Color
    
    init(color: Color) {
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color, radius: 5, x: 5, y: 5)
            .shadow(color: color, radius: 5, x: -5, y: -5)
    }
}

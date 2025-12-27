//
//  GlowColorView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 27/08/2024.
//

import SwiftUI

struct GlowColorView: ViewModifier {
    
    let color: Color
    let intensity: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            content
                .blur(radius: intensity)
                .brightness(intensity)
                .colorMultiply(color)
        }
    }
    
}

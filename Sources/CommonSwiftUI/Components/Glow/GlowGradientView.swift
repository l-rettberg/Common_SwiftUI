//
//  GlowGradientView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 27/08/2024.
//

import SwiftUI

struct GlowGradientView: ViewModifier {
    
    var gradient: LinearGradient
    var intensity: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            // Glow layer
            content
            
            content
                .blur(radius: intensity)
                .overlay(gradient)
                .mask(content.blur(radius: intensity))
            
        }
    }
    
}

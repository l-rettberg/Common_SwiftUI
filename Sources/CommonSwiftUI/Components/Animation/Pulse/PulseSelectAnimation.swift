//
//  PulseAnimation.swift
//  CommonSwiftUI
//
//  Created by James Thang on 11/2/25.
//

import SwiftUI

/// A SwiftUI view that provides a pulsing animation to indicate selection or focus.
///
/// `PulseSelectAnimation` animates two concentric circles to create a pulse effect:
/// - The **outer circle** is drawn with a stroke that scales from 0.7 to 1 and fades its opacity from fully opaque to 20% opacity.
/// - The **inner circle** fills with the provided color when pulsing, and remains clear when not active.
///
/// Both circles animate concurrently using an ease-in-out timing over a duration of 1.5 seconds, and the animation
/// repeats forever with an autoreverse effect. The view uses a `GeometryReader` to adapt its size to the available space,
/// ensuring that the animation scales appropriately based on its parent’s frame.
///
/// This component is ideal for situations where you need to visually emphasize a selected or active element in your UI.
///
/// ### Example Usage
/// ```swift
/// PulseSelectAnimation(color: .red)
///     .frame(width: 150, height: 150)
/// ```
///
/// - Parameter color: The color used for the stroke and fill of the pulse animation.
public struct PulseSelectAnimation: View {
    
    private let colorToShow: Color
    @State private var isPulsing = false
    
    public init(color: Color) {
        self.colorToShow = color
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                Circle()
                    .stroke(lineWidth: size * 0.0833)
                    .foregroundColor(colorToShow)
                    .scaleEffect(isPulsing ? 1 : 0.7)
                    .opacity(isPulsing ? 0.2 : 1)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                
                Circle()
                    .fill(isPulsing ? colorToShow : .clear)
                    .frame(width: size * (100 / 120), height: size * (100 / 120))
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            isPulsing = true
        }
    }
    
}

#Preview {
    VStack(spacing: 50) {
        PulseSelectAnimation(color: .red)
            .frame(width: 100, height: 100)
        
        PulseSelectAnimation(color: .blue)
            .frame(width: 150, height: 150)
    }
}

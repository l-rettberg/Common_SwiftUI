//
//  FancyLoadingView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 01/06/2024.
//

import SwiftUI

/// A SwiftUI view that displays a series of animated concentric circles, creating a dynamic loading indicator.
///
/// `FancyLoading` creates a visually engaging loading animation using multiple circles that expand and contract. The animation is customizable through the `color` property, allowing for integration with different UI themes.
///
/// - Parameters:
///   - color: The color of the circle strokes. The default is `.primary`.
///
/// Each circle in the animation is individually timed to create a smooth, rhythmic effect that visually indicates an ongoing process.
///
/// ## Example Usage:
/// ```swift
/// FancyLoading(color: .blue)
/// ```
///
/// This component is ideal for use in places where a stylish loading indicator is needed to enhance the user experience during longer wait times.
/// 
public struct FancyLoading: View {
   
    private var color: Color
    @State private var moving = false
    
    public init(color: Color = .primary) {
        self.color = color
    }
    
    public var body: some View {
        ZStack {
            ForEach(0...7, id: \.self) { index in
                let radius: CGFloat = CGFloat(20 + (30 * index))
                let delay: CGFloat = CGFloat(index) * 0.05
                CircleComponent(radius: radius, delay: delay)
            }
        }
        .onAppear {
            moving.toggle()
        }
    }
    
    @ViewBuilder
    private func CircleComponent(radius: CGFloat, delay: CGFloat) -> some View {
        Circle()
            .stroke(lineWidth: 5)
            .foregroundStyle(color)
            .frame(width: radius, height: radius)
            .rotation3DEffect(
                .degrees(75),
                axis: (x: 1.0, y: 0.0, z: 0.0)
            )
            .offset(y: moving ? 150 : -180)
            .animation(.interpolatingSpring(stiffness: 100, damping: 5).repeatForever(autoreverses: true).delay(delay), value: moving)
    }
    
}


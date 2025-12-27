//
//  TinderPulseAnimation.swift
//  CommonSwiftUI
//
//  Created by James Thang on 12/2/25.
//

import SwiftUI

/// A customizable pulse animation view that displays a ripple effect with developer-provided content.
///
/// `PulseAnimation` creates an animated ripple effect using multiple expanding circles that fade out
/// as they scale. In the center, it displays custom content which is clipped to a circular shape.
/// This effect is similar to the pulse or ripple animations seen in various modern apps (e.g., Tinder).
///
/// The animation is highly configurable:
/// - You can specify the color of the ripple circles.
/// - The number of ripple circles is adjustable.
/// - The duration of the animation cycle can be set.
/// - The starting and ending scales of the circles are configurable.
///
/// Use this view to draw attention to a particular element, or as an eye-catching background effect.
///
/// ## Example Usage
/// ```swift
/// PulseAnimation(color: .blue, count: 8, duration: 2.5, startScale: 0.5, endScale: 1.5) {
///     Image(systemName: "heart.fill")
///         .resizable()
///         .scaledToFit()
///         .foregroundColor(.white)
/// }
/// .frame(width: 200, height: 200)
/// ```
///
/// - Parameters:
///   - color: The color used for the stroke of the ripple circles.
///   - count: The number of ripple circles to animate. Defaults to 8.
///   - duration: The total duration of one ripple animation cycle in seconds. Defaults to 2.5 seconds.
///   - startScale: The initial scale factor for each ripple circle. Defaults to 0.5.
///   - endScale: The final scale factor for each ripple circle. Defaults to 1.5.
///   - content: A closure that returns the view to be displayed in the center of the animation. The content will be clipped to a circle.
public struct PulseAnimation<Content: View>: View {
    
    private let colorToShow: Color
    private let count: Int
    public let animationDuration: Double
    private let startScale: CGFloat
    private let endScale: CGFloat
    private let content: Content

    @State private var animate: Bool = false
    
    public init(
        color: Color,
        count: Int = 8,
        duration: Double = 2.5,
        startScale: CGFloat = 0.5,
        endScale: CGFloat = 1.5,
        @ViewBuilder content: () -> Content
    ) {
        self.colorToShow = color
        self.count = count
        self.animationDuration = duration
        self.startScale = startScale
        self.endScale = endScale
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                ForEach(0..<count, id: \.self) { i in
                    Circle()
                        .stroke(colorToShow, lineWidth: size * 0.05)
                        .frame(width: size, height: size)
                        .scaleEffect(animate ? endScale : startScale)
                        .opacity(animate ? 0 : 1)
                        .animation(
                            Animation.easeOut(duration: animationDuration)
                                .repeatForever(autoreverses: false)
                                .delay(Double(i) * (animationDuration / Double(count))),
                            value: animate
                        )
                }
                
                content
                    .frame(width: size * 0.8, height: size * 0.8)
                    .clipShape(.circle)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    VStack(spacing: 50) {
        PulseAnimation(color: .yellow) {
            Color.blue
        }
        .frame(width: 100, height: 100)

        PulseAnimation(color: .green) {
            ZStack {
                Color.green

                Image(systemName: "phone.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 100, height: 100)
        
        PulseAnimation(color: .red) {
            ZStack {
                Color.red
                
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            }
        }
        .frame(width: 100, height: 100)
    }
}

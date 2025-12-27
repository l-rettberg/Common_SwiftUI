//
//  BounceAnimation.swift
//  CommonSwiftUI
//
//  Created by James Thang on 12/2/25.
//

import SwiftUI

/// A view that displays an SF Symbol with a bouncy animation effect.
///
/// `BouncyAnimation` leverages iOS 17’s `.symbolEffect(.bounce, ...)` modifier to create a bouncing effect on SF Symbols.
/// The animation is driven by an internal toggle that updates periodically even when the external animation binding (`isAnimating`) remains constant.
/// This view is generic over any type conforming to `ShapeStyle`, allowing flexible customization of the symbol's appearance (for example, using colors or gradients).
///
/// The animation speed is configurable using a custom `Speed` enumeration, which provides predefined speeds or a custom time interval.
///
/// - Note: The bounce effect is only supported on SF Symbols. Ensure that the `systemName` parameter corresponds to a valid SF Symbol name.
///
/// - Parameters:
///   - systemName: A `String` representing the name of the SF Symbol to display.
///   - size: A `CGFloat` specifying the font size applied to the symbol. The default value is `80`.
///   - foregroundStyle: A value conforming to `ShapeStyle` that determines the foreground style of the symbol. The default is `.red.gradient`.
///   - isAnimating: A `Binding<Bool>` that controls whether the bounce animation is active.
///   - speed: A `Speed` value that determines the repetition speed of the bounce effect. Defaults to `.fast`.
///
/// Usage Example:
/// ```swift
/// struct ContentView: View {
///     @State private var animate = true
///
///     var body: some View {
///         BouncyAnimation(
///             systemName: "heart.fill",
///             size: 100,
///             foregroundStyle: Color.pink.gradient,
///             isAnimating: $animate,
///             speed: .fast
///         )
///     }
/// }
/// ```
@available(iOS 17.0, *)
public struct BouncyAnimation<S: ShapeStyle>: View {
    
    private let systemName: String
    private let size: CGFloat
    private let style: S
    @Binding var isAnimating: Bool
    private let speed: Speed
    @State private var internalToggle: Bool = false
    @State private var animationTask: Task<Void, Never>? = nil
    
    public init(
        systemName: String,
        size: CGFloat = 80,
        color: S = .red.gradient,
        isAnimating: Binding<Bool>,
        speed: Speed = .fast
    ) {
        self.systemName = systemName
        self.size = size
        self.style = color
        self._isAnimating = isAnimating
        self.speed = speed
    }
    
    public var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size))
            .foregroundStyle(style)
            .symbolEffect(
                .bounce,
                options: isAnimating ? .repeating.speed(speed.timeInterval) : .default,
                value: isAnimating ? internalToggle : false
            )
            .onAppear {
                if isAnimating {
                    startInternalAnimation()
                }
            }
            .onChange(of: isAnimating) { _, newValue in
                if newValue {
                    startInternalAnimation()
                } else {
                    stopInternalAnimation()
                }
            }
            .onDisappear {
                animationTask?.cancel()
            }
    }
    
    private func startInternalAnimation() {
        guard animationTask == nil else { return }
        animationTask = Task {
            while !Task.isCancelled && isAnimating {
                try? await Task.sleep(nanoseconds: 1_000_000)
                await MainActor.run {
                    internalToggle.toggle()
                }
            }
            animationTask = nil
        }
    }
    
    private func stopInternalAnimation() {
        Task {
            try? await Task.sleep(nanoseconds: 200_000_000)
            await MainActor.run {
                withAnimation {
                    internalToggle = false
                }
                animationTask?.cancel()
                animationTask = nil
            }
        }
    }
    
}

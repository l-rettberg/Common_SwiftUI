//
//  Image+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 13/2/25.
//

import SwiftUI

@available(iOS 17.0, *)
/// A view modifier that applies a bouncy animation effect to an SF Symbol.
///
/// The modifier leverages iOS 17’s `.symbolEffect(.bounce, ...)` to create a bouncing effect.
/// The animation is driven by an internal toggle that updates periodically even when the external
/// animation binding (`isAnimating`) remains constant. The effect is configurable via a `Speed`
/// value and a custom foreground style.
struct BouncyAnimationModifier: ViewModifier {
    
    private let speed: Speed
    @Binding var isAnimating: Bool

    @State private var internalToggle: Bool = false
    @State private var animationTask: Task<Void, Never>? = nil
    
    init(speed: Speed, isAnimating: Binding<Bool>) {
        self.speed = speed
        self._isAnimating = isAnimating
    }

    func body(content: Content) -> some View {
        content
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
    
    /// Starts the internal asynchronous task to drive the bounce effect.
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
    
    /// Stops the internal animation with a slight delay to allow a smooth finish.
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

@available(iOS 17.0, *)
extension Image {
    
    /// Applies a bouncy animation effect to an SF Symbol image.
    ///
    /// The effect uses iOS 17’s `.symbolEffect(.bounce, ...)` modifier and is driven by an internal toggle.
    /// The bounce speed is controlled via a custom `Speed` value, and the image’s foreground style is applied
    /// through the provided parameter.
    ///
    /// - Parameters:
    ///   - isAnimating: A binding to a Boolean value that controls whether the bounce animation is active.
    ///   - speed: A `Speed` value that determines the repetition speed of the bounce effect. Defaults to `.fast`.
    /// - Returns: A view that applies the bouncy animation effect.
    public func bouncyAnimation(
        isAnimating: Binding<Bool>,
        speed: Speed = .fast
    ) -> some View {
        self.modifier(BouncyAnimationModifier(speed: speed, isAnimating: isAnimating))
    }
    
}

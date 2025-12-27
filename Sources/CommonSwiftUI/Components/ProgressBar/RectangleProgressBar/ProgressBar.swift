//
//  ProgressBar.swift
//  Productivity
//
//  Created by James Thang on 31/03/2022.
//

import SwiftUI

/// A rectangular progress bar view for SwiftUI that supports a shimmer effect.
///
/// This view displays a customizable progress bar that fills up based on the current `progress`. It can be customized with different colors, a background color, and an optional shimmer effect for visual enhancement.
///
/// - Parameters:
///   - progress: A binding to a `CGFloat` representing the current progress (from 0.0 to 1.0).
///   - colors: An array of `Color` to create a gradient for the progress bar. If a single color is needed, use the `color` initializer.
///   - backgroundColor: The color of the progress bar's background.
///   - shimmer: A Boolean value that determines whether a shimmer effect should be applied to the progress bar.
///
/// ## Usage
/// Single Color with Shimmer:
/// ```swift
/// ProgressBar(
///     progress: $yourProgressVariable,
///     color: .red,
///     backgroundColor: .gray.opacity(0.3),
///     shimmer: true
/// )
/// ```
/// Gradient of Colors with Shimmer:
/// ```swift
/// ProgressBar(
///     progress: $yourProgressVariable,
///     colors: [.red, .orange],
///     backgroundColor: .gray.opacity(0.3),
///     shimmer: true
/// )
/// ```
///
/// - Note: You can enable the shimmer effect to add a dynamic visual appearance during the loading process. The shimmer effect starts automatically when the component appears or the progress changes.
public struct ProgressBar: View {
    
    @Binding var progress: CGFloat
    private var colors: [Color]
    private var backgroundColor: Color
    private var shimmer: Bool
    @State private var isShimmering: Bool = false
    
    public init(progress: Binding<CGFloat>, color: Color, backgroundColor: Color = .secondary.opacity(0.3), shimmer: Bool = false) {
        self._progress = progress
        self.colors = [color]
        self.backgroundColor = backgroundColor
        self.shimmer = shimmer
    }
    
    public init(progress: Binding<CGFloat>, colors: [Color], backgroundColor: Color = .secondary.opacity(0.3), shimmer: Bool = false) {
        self._progress = progress
        self.colors = colors
        self.backgroundColor = backgroundColor
        self.shimmer = shimmer
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .frame(width: width, height: height)
                .foregroundStyle(backgroundColor)
            
            RoundedRectangle(cornerRadius: height, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
                .frame(width: width * progress, height: height)
                .clipShape(RoundedRectangle(cornerRadius: height, style: .continuous))
                .animation(.easeInOut, value: progress)
                .shimmer(isActive: $isShimmering, tint: .gray.opacity(0.1), highlight: .white, blur: 5)
        }
        .onLoad {
            isShimmering = shimmer
        }
        .customChange(value: progress) { newValue in
            if shimmer {
                isShimmering = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isShimmering = true
                }
            }
        }
    }
    
}

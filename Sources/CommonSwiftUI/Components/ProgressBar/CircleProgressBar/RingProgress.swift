//
//  RingProgress.swift
//  CommonSwiftUI
//
//  Created by James Thang on 17/03/2024.
//

import SwiftUI

/// A circular progress bar view for SwiftUI.
///
/// This view displays a circular progress indicator that fills up based on the current `progress`. The progress circle can be customized with different `lineWidth`, `startAngle`, `colors`, and a `backgroundColor`.
///
/// - Parameters:
///   - progress: A binding to a `CGFloat` that represents the current progress (from 0.0 to 1.0).
///   - lineWidth: The thickness of the progress bar's line.
///   - startAngle: The angle at which the progress starts, with `.zero` being the default.
///   - colors: An array of `Color` to create a gradient for the progress bar (used when more than one color is desired).
///   - backgroundColor: The color of the bar's background.
///
/// ## Usage
/// Single Color:
/// ```swift
/// RingProgress(
///     progress: $yourProgressVariable,
///     lineWidth: 5,
///     startAngle: .degrees(-90),
///     color: .blue,
///     backgroundColor: .gray.opacity(0.3)
/// )
/// ```
/// Gradient of Colors:
/// ```swift
/// RingProgress(
///     progress: $yourProgressVariable,
///     lineWidth: 5,
///     startAngle: .degrees(-90),
///     colors: [.blue, .green],
///     backgroundColor: .gray.opacity(0.3)
/// )
/// ```
///
/// - Note: You can use either a single color or a gradient of colors for the progress bar.
public struct RingProgress: View {
    
    @Binding var progress: CGFloat
    private var lineWidth: CGFloat
    private var startAngle: Angle
    private var colors: [Color]
    private var backgroundColor: Color
    
    public init(progress: Binding<CGFloat>, lineWidth: CGFloat, startAngle: Angle = .zero, color: Color, backgroundColor: Color = .secondary.opacity(0.3)) {
        self._progress = progress
        self.lineWidth = lineWidth
        self.startAngle = startAngle
        self.colors = [color]
        self.backgroundColor = backgroundColor
    }
    
    public init(progress: Binding<CGFloat>, lineWidth: CGFloat, startAngle: Angle = .zero, colors: [Color], backgroundColor: Color = .secondary.opacity(0.3)) {
        self._progress = progress
        self.lineWidth = lineWidth
        self.startAngle = startAngle
        self.colors = colors
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(backgroundColor)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
        }
        .rotationEffect(startAngle)
    }
}


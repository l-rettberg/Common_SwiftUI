//
//  ArcProgress.swift
//  CommonSwiftUI
//
//  Created by James Thang on 05/08/2022.
//

import SwiftUI

/// A customizable circular progress bar for SwiftUI, unique for its adjustable trim and rotation.
///
/// This view displays a circular progress indicator that fills up based on the current `progress`, but unlike traditional full-circle progress bars, this one fills up to 75% of the circle. The progress circle can be customized with different `lineWidth`, `colors`, and a `backgroundColor`.
///
/// - Parameters:
///   - progress: A binding to a `CGFloat` reflecting the current progress (from 0.0 to 1.0).
///   - lineWidth: The thickness of the progress bar's line.
///   - colors: An array of `Color` for creating a gradient (for multiple colors).
///   - backgroundColor: The color of the bar's background.
///
/// ## Usage
/// Single Color:
/// ```swift
/// ArcProgress(
///     progress: $yourProgressVariable,
///     lineWidth: 5,
///     color: .blue,
///     backgroundColor: .gray.opacity(0.3)
/// )
/// ```
/// Gradient of Colors:
/// ```swift
/// ArcProgress(
///     progress: $yourProgressVariable,
///     lineWidth: 5,
///     colors: [.blue, .green],
///     backgroundColor: .gray.opacity(0.3)
/// )
/// ```
///
/// - Note: The progress bar uniquely fills up to 75% of the circle and starts at a 135-degree angle.
public struct ArcProgress: View {
    
    @Binding var progress: CGFloat
    private var lineWidth: CGFloat
    private var colors: [Color]
    private var backgroundColor: Color
    
    public init(progress: Binding<CGFloat>, lineWidth: CGFloat, color: Color, backgroundColor: Color = .secondary.opacity(0.3)) {
        self._progress = progress
        self.lineWidth = lineWidth
        self.colors = [color]
        self.backgroundColor = backgroundColor
    }
    
    public init(progress: Binding<CGFloat>, lineWidth: CGFloat, colors: [Color], backgroundColor: Color = .secondary.opacity(0.3)) {
        self._progress = progress
        self.lineWidth = lineWidth
        self.colors = colors
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(backgroundColor)

            Circle()
                .trim(from: 0, to: min(self.progress * 0.75, 1))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing))
        }
        .rotationEffect(Angle(degrees: 135))
    }
}



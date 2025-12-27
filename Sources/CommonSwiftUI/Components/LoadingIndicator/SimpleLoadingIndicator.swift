//
//  SimpleLoadingIndicator.swift
//  CommonSwiftUI
//
//  Created by James Thang on 04/09/2023.
//

import SwiftUI

/// A simple, customizable loading indicator view.
///
/// This view displays a circular loading indicator that rotates according to the specified loading speed. The appearance of the indicator, including its color, background color, line width, and speed, can be customized.
///
/// - Parameters:
///   - color: The color of the loading indicator. Default is `.blue`.
///   - backgroundColor: The background color of the loading indicator. Default is `.gray`.
///   - lineWidth: The thickness of the loading indicator's line. Default is 5.
///   - loadingSpeed: The speed at which the loading indicator rotates. Default is `.medium`.
///
/// ## Usage:
/// ```swift
/// SimpleLoadingIndicator(color: .red, backgroundColor: .black, lineWidth: 8, loadingSpeed: .fast)
/// ```
///
/// The loading indicator will rotate continuously to signify an ongoing loading process.
/// 
public struct SimpleLoadingIndicator: View {
    
    @State private var isLoading = false
    private var loadingColor: Color
    private var backgroundColor: Color
    private var lineWidth: CGFloat
    private var loadingSpeed: Speed
    
    public init(color: Color = .blue, backgroundColor: Color = .gray, lineWidth: CGFloat = 5, loadingSpeed: Speed = .medium) {
        self.loadingColor = color
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
        self.loadingSpeed = loadingSpeed
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .fill(backgroundColor)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .fill(.linearGradient(colors: [loadingColor, loadingColor.opacity(0.85), loadingColor.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: loadingSpeed.timeInterval).repeatForever(autoreverses: false), value: isLoading)
                .onAppear {
                    isLoading = true
                }
        }
        .padding()
    }
    
}

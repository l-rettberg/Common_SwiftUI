//
//  GlassMorphism.swift
//  CommonSwiftUI
//
//  Created by James Thang on 28/03/2024.
//

import SwiftUI

/// A view creating a glassmorphism effect with customizable properties.
///
/// This view uses blur and saturation effects to achieve a frosted glass look, further enhanced with a customizable border. The effect's intensity and appearance can be tailored through parameters for corner radius, blur, saturation, and border thickness.
///
/// - Parameters:
///   - cornerRadius: The radius of the corners for the card. Default is 0.
///   - blurRadius: The intensity of the blur effect. A value of 0 uses the system default.
///   - saturationAmount: The saturation effect's intensity. A value of 0 uses the system default.
///   - border: The thickness of the card's border. Default is 0 (no border).
///
/// ## Usage:
/// ```swift
/// ZStack {
///     Circle().frame(width: 100, height: 100).foregroundColor(.red)
///     GlassMorphismView(cornerRadius: 20, blurRadius: 10, saturationAmount: 1.8, border: 2)
///     Text("Hello World")
/// }
/// ```
/// This example illustrates the `GlassMorphismView` with a circular red background, a specified border, and overlaid text to demonstrate the glassmorphism effect.
public struct GlassMorphismView: View {
    
    @State private var blurView: UIVisualEffectView = .init()
    @State private var defaultBlurRadius: CGFloat = 0
    @State private var defaultSaturationAmount: CGFloat = 0
    private var cornerRadius: CGFloat
    private var blurRadius: CGFloat
    private var saturationAmount: CGFloat
    private var border: CGFloat
    
    public init(cornerRadius: CGFloat = 0, blurRadius: CGFloat = 0, saturationAmount: CGFloat = 0, border: CGFloat = 0) {
        self.cornerRadius = cornerRadius
        self.blurRadius = blurRadius
        self.saturationAmount = saturationAmount
        self.border = border
    }
    
    public var body: some View {
        ZStack {
            BlurView(effect: .systemUltraThinMaterialDark) { view in
                blurView = view
                if defaultBlurRadius == 0 {
                    defaultBlurRadius = view.gaussianBlurRadius
                }
                if defaultSaturationAmount == 0 {
                    defaultSaturationAmount = view.saturationAmount
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            
            // Build Glassmophic Card
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(
                    .linearGradient(
                        colors: [
                            .white.opacity(0.25),
                            .white.opacity(0.05),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
                )
                .blur(radius: 5)
            
            // Border
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(0.6),
                            .clear,
                            .white.opacity(0.2),
                            .white.opacity(0.5)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing),
                    lineWidth: border
                )
        }
        // Shadow
        .shadow(color: .black.opacity(0.15), radius: 5, x: -10, y: 10)
        .shadow(color: .black.opacity(0.15), radius: 5, x: 10, y: -10)
        .onLoad {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                blurView.gaussianBlurRadius = blurRadius == 0 ? defaultBlurRadius : blurRadius
                blurView.saturationAmount = saturationAmount == 0 ? defaultSaturationAmount : saturationAmount
            }
        }
    }
    
}


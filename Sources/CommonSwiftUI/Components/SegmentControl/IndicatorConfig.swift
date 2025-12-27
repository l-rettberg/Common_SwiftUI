//
//  IndicatorConfig.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/03/2024.
//

import SwiftUI

/// Configuration for visual indicators in UI components.
///
/// Allows for the customization of indicators, including their color (`tint`), corner radius for rounded edges, and overall style (`style`). This struct is utilized to define the appearance and thematic consistency of indicators across the application.
///
/// - Parameters:
///   - tint: The color of the indicator. Default is `.blue`.
///   - cornerRadius: The radius of the corners for the indicator. Allows for rounded edge design.
///   - style: The `IndicatorStyle` determining the indicator's positioning and behavior.
public struct IndicatorConfig {
    let tint: Color
    let cornerRadius: CGFloat
    let style: IndicatorStyle
    
    public init(tint: Color = .blue, cornerRadius: CGFloat, style: IndicatorStyle) {
        self.tint = tint
        self.cornerRadius = cornerRadius
        self.style = style
    }
}

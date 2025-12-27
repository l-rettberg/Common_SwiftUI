//
//  IndicatorStyle.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/03/2024.
//

import Foundation

/// Defines the style for indicators within UI components.
///
/// This enumeration distinguishes between two styles of indicators, allowing for customization based on their intended visual effect or positioning. The style can be applied to various UI elements, enhancing their interactivity and visual feedback.
///
/// - Cases:
///   - bottom: Indicates an indicator should appear at the bottom of the component.
///   - background: Indicates the indicator should cover the background of the component, possibly as an overlay or fill.
public enum IndicatorStyle {
    case bottom
    case background
}

//
//  GradientDirection.swift
//  CommonSwiftUI
//
//  Created by James Thang on 07/10/2024.
//

import Foundation

/// Represents the possible directions for a gradient application.
///
/// The `GradientDirection` enum defines directional options for gradient layers, allowing precise control over the gradient flow on a QR code or any graphical representation requiring gradient effects.
///
/// - Variants:
///   - `top`: Gradient flows from top to bottom.
///   - `bottom`: Gradient flows from bottom to top.
///   - `leading`: Gradient flows from left to right.
///   - `trailing`: Gradient flows from right to left.
///   - `topLeading`: Gradient flows from top-left to bottom-right.
///   - `topTrailing`: Gradient flows from top-right to bottom-left.
///   - `bottomLeading`: Gradient flows from bottom-left to top-right.
///   - `bottomTrailing`: Gradient flows from bottom-right to top-left.
///   - `custom(startPoint, endPoint)`: Allows custom definition of the start and end points for the gradient.
///
/// Each variant provides a method to calculate the start and end points based on the size of the canvas, facilitating dynamic gradient applications.
public enum GradientDirection {
    case top
    case bottom
    case leading
    case trailing
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    case custom(startPoint: CGPoint, endPoint: CGPoint)

    func points(for size: CGSize) -> (startPoint: CGPoint, endPoint: CGPoint) {
        switch self {
        case .top:
            return (CGPoint(x: size.width / 2, y: 0), CGPoint(x: size.width / 2, y: size.height))
        case .bottom:
            return (CGPoint(x: size.width / 2, y: size.height), CGPoint(x: size.width / 2, y: 0))
        case .leading:
            return (CGPoint(x: 0, y: size.height / 2), CGPoint(x: size.width, y: size.height / 2))
        case .trailing:
            return (CGPoint(x: size.width, y: size.height / 2), CGPoint(x: 0, y: size.height / 2))
        case .topLeading:
            return (CGPoint(x: 0, y: 0), CGPoint(x: size.width, y: size.height))
        case .topTrailing:
            return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
        case .bottomLeading:
            return (CGPoint(x: 0, y: size.height), CGPoint(x: size.width, y: 0))
        case .bottomTrailing:
            return (CGPoint(x: size.width, y: size.height), CGPoint(x: 0, y: 0))
        case .custom(let startPoint, let endPoint):
            return (startPoint, endPoint)
        }
    }
}

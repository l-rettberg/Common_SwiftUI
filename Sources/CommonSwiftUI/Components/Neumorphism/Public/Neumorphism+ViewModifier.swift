//
//  Neumorphism.swift
//  CommonSwiftUI
//
//  Created by James Thang on 04/09/2023.
//

import SwiftUI

extension View {
    /// Applies a neumorphic effect to any view.
    ///
    /// This function adds a soft inner or outer shadow to the view to create a neumorphic effect, which gives the appearance of the view being embedded in the background.
    /// - Parameters:
    ///   - color: The color of the  shadow.
    ///
    /// ## Usage:
    /// ```swift
    /// Circle()
    ///     .frame(width: 200, height: 200)
    ///     .foregroundStyle(.white)
    ///     .neumorphism(color: .gray.opacity(0.5))
    /// ```
    public func neumorphism(color: Color) -> some View {
        modifier(Neumorphism(color: color))
    }
}

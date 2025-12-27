//
//  ButtonStyle+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 25/1/25.
//

import SwiftUI

public extension ButtonStyle where Self == CapsuleButtonStyle<Color, Color> {
    /**
     Creates a capsule-shaped button style with solid colors for both the text and background.
     
     - Parameters:
     - textColor: The color used for the button text. Defaults to `.white`.
     - backgroundColor: The color used for the button background. Defaults to `.blue`.
     - verticalPadding: The amount of vertical padding inside the button. Defaults to `10`.
     - horizontalPadding: The amount of horizontal padding inside the button. Defaults to `20`.
     
     - Returns: A `CapsuleButtonStyle` configured with the specified text color, background color, and padding.
     */
    static func capsule(
        textColor: Color = .white,
        backgroundColor: Color = .blue,
        verticalPadding: CGFloat = 10,
        horizontalPadding: CGFloat = 20
    ) -> Self {
        .init(
            textColor: textColor,
            backgroundColor: backgroundColor,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding
        )
    }
}

public extension ButtonStyle where Self == CapsuleButtonStyle<Color, LinearGradient> {
    /**
     Creates a capsule-shaped button style with a solid color for the text and a `LinearGradient` for the background.
     
     - Parameters:
     - textColor: The color used for the button text. Defaults to `.white`.
     - backgroundColor: The gradient used for the button background.
     - verticalPadding: The amount of vertical padding inside the button. Defaults to `10`.
     - horizontalPadding: The amount of horizontal padding inside the button. Defaults to `20`.
     
     - Returns: A `CapsuleButtonStyle` configured with the specified text color, gradient background, and padding.
     */
    static func capsule(
        textColor: Color = .white,
        backgroundColor: LinearGradient,
        verticalPadding: CGFloat = 10,
        horizontalPadding: CGFloat = 20
    ) -> Self {
        .init(
            textColor: textColor,
            backgroundColor: backgroundColor,
            verticalPadding: verticalPadding,
            horizontalPadding: horizontalPadding
        )
    }
}

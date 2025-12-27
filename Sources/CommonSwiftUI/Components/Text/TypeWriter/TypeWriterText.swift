//
//  TypeWriterText.swift
//  CommonSwiftUI
//
//  Created by James Thang on 30/05/2024.
//

import SwiftUI

/// A SwiftUI view that simulates a typewriter effect for displaying text.
///
/// This view gradually displays characters of a string, mimicking the typing effect seen in a typewriter. Customization options include font, weight, color, alignment, and the speed of typing. The speed of typing can be one of the predefined speeds or a custom duration specified in seconds.
///
/// - Parameters:
///   - text: The text to display using the typewriter effect.
///   - font: The font style of the text. Default is `.caption`.
///   - fontWeight: The weight of the font. Default is `.medium`.
///   - color: The color of the text. Default is `.primary`.
///   - alignment: The alignment of the text within its container. Default is `.center`.
///   - speed: The speed at which characters are displayed. Default is `.flash` for 0.1 second.
///
/// ## Usage Example:
/// ```swift
/// TypeWriterText(text: "James Thang", font: .title, fontWeight: .regular)
/// ```
///
/// This view is ideal for scenarios where text needs to be presented in a dramatic, engaging manner.
public struct TypeWriterText: View {
    @State private var currentText: String = ""
    var text: String
    var font: Font
    var fontWeight: Font.Weight
    var color: Color
    var alignment: TextAlignment
    var speed: Speed
    
    public init(text: String, font: Font = .caption, fontWeight: Font.Weight = .medium, color: Color = .primary, alignment: TextAlignment = .center, speed: Speed = .flash) {
        self.text = text
        self.font = font
        self.fontWeight = fontWeight
        self.color = color
        self.alignment = alignment
        self.speed = speed
    }
    
    public var body: some View {
        VStack {
            Text(currentText)
                .font(font)
                .fontWeight(fontWeight)
                .foregroundStyle(color)
                .multilineTextAlignment(alignment)
        }
        .onLoad {
            typeWriter()
        }
    }
    
    
    private func typeWriter(at position: Int = 0) {
        if position == 0 {
            currentText = ""
        }
        
        if position < text.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + speed.timeInterval) {
                currentText.append(text[position])
                typeWriter(at: position + 1)
            }
        }
    }
    
}

//
//  CircularText.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/05/2024.
//

import SwiftUI

/// A SwiftUI view that arranges text in a circular path with enhanced customization.
///
/// `CircularText` displays text along a specified radius, offering settings for alignment, character spacing, and style reversal. It utilizes a generic view modifier to apply custom styling to each character, making it versatile for various design needs.
///
/// - Parameters:
///   - text: The string of text to be displayed circularly.
///   - radius: The radius of the circle along which the text is arranged.
///   - spacing: The spacing between characters, defaulting to 4.
///   - alignment: The position of the text relative to the circle's radius (`inside`, `center`, `outside`).
///   - reverseStyle: If `true`, reverses the direction and orientation of the text.
///   - textModifier: A closure that allows for custom styling of the text, applied per character.
///
/// ## Example Usage:
/// ```swift
/// CircularText(text: "Hello, world", radius: 100, alignment: .center, textModifier: { Text($0).fontWeight(.bold) })
/// ```
///
/// This view is perfect for creating visually compelling text effects such as circular labels or decorative text in a SwiftUI application.
///
public struct CircularText<Content: View>: View {

    /// An enumeration representing the alignment of text in relation to a specified radius in the `CircularText` view.
    ///
    /// This enum defines how text should be positioned around a circle, affecting how the text is perceived in relation to the circular path.
    ///
    /// - Cases:
    ///   - inside: Positions the text so that it is aligned along the inner edge of the specified radius. The text will appear closer to the center of the circle.
    ///   - center: Aligns the text directly on the specified radius, placing it at the midpoint between the inner and outer edges. This is the default position.
    ///   - outside: Places the text along the outer edge of the radius. The text will appear further from the center, extending outward.
    ///
    /// These alignment options provide flexibility in designing circular text presentations, allowing for aesthetic adjustments based on the desired visual impact.
    public enum Position {
        case inside, center, outside
    }

    // View Properties
    private let text: String
    private let radius: CGFloat
    private var spacing: CGFloat
    private let alignment: Position
    private var reverseStyle: Bool = false
    private var textModifier: (Text) -> Content

    @State private var sizes: [CGSize] = []

    public init(text: String,
                radius: CGFloat,
                spacing: CGFloat = 4,
                alignment: Position = .center,
                reverseStyle: Bool = false,
                textModifier: @escaping (Text) -> Content = { $0 }) {
        self.text = text
        self.radius = radius
        self.spacing = spacing
        self.alignment = alignment
        self.reverseStyle = reverseStyle
        self.textModifier = textModifier
    }

    public var body: some View {
        VStack {
            ZStack {
                ForEach(textAsCharacters()) { item in
                    PropagateSize {
                        self.textView(char: item)
                            .rotation3DEffect(.degrees(reverseStyle ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                            .rotation3DEffect(.degrees(reverseStyle ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(width: self.size(at: item.index).width,
                           height: self.size(at: item.index).height)
                    .offset(x: 0,
                            y: -self.textRadius(at: item.index))
                    .rotationEffect(reverseStyle ? -self.angle(at: item.index) : self.angle(at: item.index))
                }
            }
            .frame(width: radius * 2, height: radius * 2)
            .onPreferenceChange(TextViewSizeKey.self) { sizes in
                self.sizes = sizes
            }
        }
        .accessibility(label: Text(text))
    }
    
    private func textRadius(at index: Int) -> CGFloat {
        switch alignment {
        case .inside:
            return radius - size(at: index).height / 2
        case .center:
            return radius
        case .outside:
            return radius + size(at: index).height / 2
        }
    }

    private func textAsCharacters() -> [IdentifiableCharacter] {
        text.enumerated().map(IdentifiableCharacter.init)
    }

    private func textView(char: IdentifiableCharacter) -> some View {
        textModifier(Text(char.string))
    }

    private func size(at index: Int) -> CGSize {
        sizes[safe: index] ?? CGSize(width: 1000000, height: 0)
    }

    private func angle(at index: Int) -> Angle {
        let arcSpacing = Double(spacing / radius)
        let letterWidths = sizes.map { $0.width }
        let prevWidth =
            index < letterWidths.count ?
            letterWidths.dropLast(letterWidths.count - index).reduce(0, +) :
            0
        let prevArcWidth = Double(prevWidth / radius)
        let totalArcWidth = Double(letterWidths.reduce(0, +) / radius)
        let prevArcSpacingWidth = arcSpacing * Double(index)
        let arcSpacingOffset = -arcSpacing * Double(letterWidths.count - 1) / 2
        let charWidth = letterWidths[safe: index] ?? 0
        let charOffset = Double(charWidth / 2 / radius)
        let arcCharCenteringOffset = -totalArcWidth / 2
        let charArcOffset = prevArcWidth + charOffset + arcCharCenteringOffset + arcSpacingOffset + prevArcSpacingWidth
        return Angle(radians: charArcOffset)
    }
    
}

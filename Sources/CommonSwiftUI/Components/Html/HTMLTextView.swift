//
//  HTMLTextView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 22/08/2024.
//

import UIKit
import SwiftUI

/// A UIViewRepresentable component that renders HTML content within a UILabel.
///
/// `HTMLTextView` allows SwiftUI to integrate HTML formatted text, transforming it into a styled `NSAttributedString` displayed within a UILabel. This view handles dynamic content size and adapts to the environment's constraints.
///
/// - Parameters:
///   - content: The HTML string to be rendered.
///   - font: The base font to apply to the text. HTML styling may override this font partially.
///   - textColor: The color of the text.
///
/// ## Example:
/// ```swift
/// HTMLTextView(content: "<b>Hello</b> world!", font: UIFont.systemFont(ofSize: 14), textColor: .darkGray)
/// ```
///
/// This component simplifies the display of HTML content by managing the conversion process internally and adjusting the UILabel to fit the content appropriately.
///
public struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String
    var font: UIFont
    var textColor: UIColor
    private let maxWidth: CGFloat = UIScreen.current?.bounds.width ?? UIScreen.main.bounds.width
    
    public init(content: String, font: UIFont = UIFont.systemFont(ofSize: 14), textColor: UIColor = .label) {
        self.htmlContent = content
        self.font = font
        self.textColor = textColor
    }
    
    public func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.preferredMaxLayoutWidth = maxWidth
        return label
    }
    
    public func updateUIView(_ uiView: UILabel, context: Context) {
        guard let data = htmlContent.data(using: .utf8) else { return }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            
            // Iterate over all ranges and apply the desired font and color
            attributedString.enumerateAttribute(.font, in: NSRange(location: 0, length: attributedString.length), options: []) { value, range, _ in
                if let currentFont = value as? UIFont {
                    let newFontDescriptor = font.fontDescriptor.withSymbolicTraits(currentFont.fontDescriptor.symbolicTraits) ?? font.fontDescriptor
                    let newFont = UIFont(descriptor: newFontDescriptor, size: font.pointSize)
                    attributedString.addAttribute(.font, value: newFont, range: range)
                }
            }
            
            attributedString.addAttribute(.foregroundColor, value: textColor, range: NSRange(location: 0, length: attributedString.length))
            
            uiView.attributedText = attributedString
            
            // Adjust size to fit content
            uiView.sizeToFit()
        } catch {
            uiView.text = "Failed to load content"
        }
    }
    
    public static func dismantleUIView(_ uiView: UILabel, coordinator: ()) {
        uiView.attributedText = nil
    }

    @available(iOS 16.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UILabel, context: Context) -> CGSize? {
        let size = uiView.sizeThatFits(proposal.replacingUnspecifiedDimensions())
        return size
    }
    
}

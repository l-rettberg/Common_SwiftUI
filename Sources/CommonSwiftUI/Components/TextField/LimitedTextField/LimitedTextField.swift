//
//  LimitedTextField.swift
//  CommonSwiftUI
//
//  Created by James Thang on 02/06/2024.
//

import SwiftUI

/// A SwiftUI view that provides a text field with a character limit and visual feedback on input progress.
///
/// `LimitedTextField` offers a customizable text input field that restricts the number of characters based on a specified limit. It features visual indicators such as a progress ring or text counter and can be styled with custom colors and borders.
///
/// - Parameters:
///   - config: Configuration settings including character limit, tint, resizing behavior, and typing overflow control.
///   - hint: Placeholder text displayed when the text field is empty.
///   - value: A binding to the text inputted by the user.
///
/// ## Configurations:
/// - `Config`: Manages the main settings for the text field.
///   - `limit`: The maximum number of characters.
///   - `tint`: The color of the text and progress indicators.
///   - `autoResizes`: Whether the text field should automatically resize to fit content.
///   - `allowExcessTyping`: Allows input beyond the limit without saving excess characters.
///   - `progressConfig`: Settings for the progress indicators.
///   - `borderConfig`: Styling options for the border.
/// - `ProgressConfig`: Configures visual feedback on typing progress.
///   - `showsRing`: Displays a circular progress ring.
///   - `showsText`: Shows current and maximum character counts.
///   - `alignment`: Aligns the progress text indicator.
/// - `BorderConfig`: Customizes the border appearance.
///   - `show`: Enables or disables the border.
///   - `radius`: Sets the border radius.
///   - `width`: Defines the border thickness.
///
/// ## Example Usage:
/// ```swift
/// @State private var text: String = ""
///
/// var body: some View {
///     VStack {
///         LimitedTextField(
///             config: .init(
///                 limit: 40,
///                 tint: .secondary,
///                 autoResizes: true,
///                 allowExcessTyping: false
///             ),
///             hint: "Type here",
///             value: $text
///         )
///         .frame(maxHeight: 150)
///     }
///     .padding()
/// }
/// ```
///
/// This component is ideal for forms, comments, or any user input that requires length constraints.
/// 
public struct LimitedTextField: View {
    
    // Configuration
    private var config: LimitedTextField.Config
    private var hint: String
    @Binding var value: String
    // View Properties
    @FocusState private var isKeyboardShowing: Bool
    
    public init(config: LimitedTextField.Config, hint: String, value: Binding<String>) {
        self.config = config
        self.hint = hint
        self._value = value
    }
    
    public var body: some View {
        VStack(alignment: config.progressConfig.alignment, spacing: 12) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .fill(.clear)
                    .frame(height: config.autoResizes ? 0 : nil)
                    .contentShape(.rect(cornerRadius: config.borderConfig.radius))
                    .onTapGesture {
                        /// Show Keyboard
                        isKeyboardShowing = true
                    }
                
                TextField(hint, text: $value)
                    .focused($isKeyboardShowing)
                    .onChange(of: value) { newValue in
                        guard !config.allowExcessTyping else { return }
                        value = String(value.prefix(config.limit))
                    }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .stroke(progressColor, lineWidth: config.borderConfig.width)
            }
            
            // Progress bar / Text Indicator
            HStack(alignment: .top, spacing: 12) {
                if config.progressConfig.showsRing {
                    ZStack {
                        Circle()
                            .stroke(.ultraThinMaterial, lineWidth: 5)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(progressColor, lineWidth: 5)
                            .rotationEffect(.init(degrees: -90))
                    }
                    .frame(width: 20, height: 20)
                }
                
                if config.progressConfig.showsText {
                    Text("\(value.count)/\(config.limit)")
                        .foregroundStyle(progressColor)
                }
            }
        }
    }
    
    private var progress: CGFloat {
        return max(min((CGFloat(value.count) / CGFloat(config.limit)), 1), 0)
    }
    
    private var progressColor: Color {
        return progress < 0.6 ? config.tint : progress == 1 ? .red : .orange
    }
    
    /// Configuration settings for `LimitedTextField`.
    ///
    /// - Parameters:
    ///   - limit: Maximum number of characters allowed.
    ///   - tint: Color for the text and progress indicators.
    ///   - autoResizes: A Boolean value indicating if the text field should resize based on the input content.
    ///   - allowExcessTyping: Allows typing beyond the limit if set to `true`, though excess characters won't be saved.
    ///   - progressConfig: Configuration for the progress indicators.
    ///   - borderConfig: Configuration for the border appearance.
    public struct Config {
        private(set) var limit: Int
        private(set) var tint: Color = .blue
        private(set) var autoResizes: Bool = false
        private(set) var allowExcessTyping: Bool = false
        private(set) var progressConfig: LimitedTextField.ProgressConfig
        private(set) var borderConfig: LimitedTextField.BorderConfig
        
        public init(limit: Int, tint: Color, autoResizes: Bool, allowExcessTyping: Bool, progressConfig: LimitedTextField.ProgressConfig = .init(), borderConfig: LimitedTextField.BorderConfig = .init()) {
            self.limit = limit
            self.tint = tint
            self.autoResizes = autoResizes
            self.allowExcessTyping = allowExcessTyping
            self.progressConfig = progressConfig
            self.borderConfig = borderConfig
        }
    }
    
    /// Configures the progress indicators for `LimitedTextField`.
    ///
    /// - Parameters:
    ///   - showsRing: Shows a circular progress indicator around the text field when `true`.
    ///   - showsText: Displays the current character count and the limit.
    ///   - alignment: Alignment of the text progress indicator.
    public struct ProgressConfig {
        private(set) var showsRing: Bool
        private(set) var showsText: Bool
        private(set) var alignment: HorizontalAlignment
        
        public init(showsRing: Bool = true, showsText: Bool = true, alignment: HorizontalAlignment = .trailing) {
            self.showsRing = showsRing
            self.showsText = showsText
            self.alignment = alignment
        }
    }
    
    /// Configures the border style for `LimitedTextField`.
    ///
    /// - Parameters:
    ///   - show: Determines if the border is visible.
    ///   - radius: The corner radius of the text field's border.
    ///   - width: The thickness of the border.
    public struct BorderConfig {
        private(set) var show: Bool
        private(set) var radius: CGFloat
        private(set) var width: CGFloat
        
        public init(show: Bool = true, radius: CGFloat = 8, width: CGFloat = 1.0) {
            self.show = show
            self.radius = radius
            self.width = width
        }
    }
    
}

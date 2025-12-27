//
//  View+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 17/03/2024.
//

import SwiftUI

extension View {
    /// Applies a custom transformation to a view and returns the resulting view.
    ///
    /// This function allows for applying transformations conditionally based on the iOS version. It's particularly useful for modifying views with version-specific features or styles.
    ///
    /// - Parameter transform: A closure that takes the original view as an argument and returns the modified view.
    ///
    /// ## Simplified Usage with iOS Version Check:
    /// ```swift
    /// Text("Conditional Styling")
    ///     .apply {
    ///         if #available(iOS 16.0, *) {
    ///             $0.padding()
    ///         } else {
    ///             $0.padding().background(Color.gray)
    ///         }
    ///     }
    /// ```
    /// In this usage example, padding is applied universally, but a gray background is only applied if the iOS version is below 16.0.
    public func apply<Content>(@ViewBuilder _ transform: (Self) -> Content) -> Content {
        transform(self)
    }
    
    /// Extends `View` to conditionally use different `onChange` implementations based on iOS version.
    ///
    /// This function wraps the `onChange` modifier to handle changes to a value of any `Equatable` type, executing a closure upon change. It accommodates API differences between iOS versions by adjusting the method signature and behavior accordingly.
    ///
    /// - Parameters:
    ///   - value: The value to observe for changes. Must conform to `Equatable`.
    ///   - result: A closure that is executed when the observed value changes.
    ///
    /// ## Example Usage:
    /// ```swift
    /// Text("Example")
    ///     .customChange(value: someObservableValue) { newValue in
    ///         print("Value changed to \(newValue)")
    ///     }
    /// ```
    ///
    /// Use this function to seamlessly handle value changes across different iOS versions with custom logic in the closure.
    @ViewBuilder
    public func customChange<T: Equatable>(value: T, result: @escaping (T) -> ()) -> some View {
        if #available(iOS 17, *) {
            self.onChange(of: value) { oldValue, newValue in
                result(newValue)
            }
        } else {
            self.onChange(of: value) { newValue in
                result(newValue)
            }
        }
    }
    
    /// Configures the visibility of the clear button in a `ValidationTextField`.
    ///
    /// - Parameter hidesClearButton: A Boolean that determines whether the clear button is hidden.
    ///
    /// Apply this modifier to `ValidationTextField` to control the display of the clear button, enhancing the text field's usability according to specific UI needs.
    public func clearButtonHidden(_ hidesClearButton: Bool = true) -> some View {
        environment(\.clearButtonHidden, hidesClearButton)
    }
    
    /// Configures the visibility of the secure text toggle button in a `ValidationTextField`.
    ///
    /// - Parameter hidesSecureButton: A Boolean that determines whether the secure text toggle button is hidden.
    ///
    /// This modifier is applicable to `ValidationTextField` instances configured for secure text entry. It allows the developer to control the visibility of the button used to toggle the visibility of secure (password) text.
    public func secureTextButtonHidden(_ hidesSecureButton: Bool = true) -> some View {
        environment(\.secureButtonHidden, hidesSecureButton)
    }
    
    /// Marks a `ValidationTextField` as mandatory and optionally provides a custom validation message.
    ///
    /// - Parameters:
    ///   - value: A Boolean indicating whether the field is mandatory.
    ///   - message: A custom message displayed when the field validation fails.
    ///
    /// Use this modifier to enforce input requirements, automatically providing feedback if the mandatory field is left empty.
    public func isMandatory(_ value: Bool = true, message: String = "This is a mandatory field") -> some View {
        environment(\.isMandatory, (value, message))
    }
    
    /// Adds a validation handler to a `ValidationTextField`.
    ///
    /// - Parameter validationHandler: A closure that takes the current text value and returns a `Result` indicating the validation status.
    ///
    /// This modifier allows for the application of custom validation logic, adapting the `ValidationTextField` to complex validation requirements dynamically.
    public func onValidate(validationHandler: @escaping (String) -> Result<String, Error>) -> some View {
        environment(\.validationHandler, validationHandler)
    }
    
    /// Adds form-level validation to a `ValidationTextField` using a specified validation handler.
    ///
    /// This modifier allows for complex validation logic that can validate multiple conditions and return a list of validation results. Each result can specify a unique message and a validity state, which can be used to provide detailed feedback directly related to the form input.
    ///
    /// - Parameter formValidationHandler: A closure that takes the current text value as input and returns an array of `FormValidationElement`, each representing a specific validation rule and its result.
    ///
    /// ## Usage:
    /// ```swift
    /// ValidationTextField(title: "Password", text: $password)
    ///     .onFormValidate { text in
    ///         [
    ///             FormValidationElement(message: "Password is at least 6 characters", isValid: text.count >= 6),
    ///             FormValidationElement(message: "Password includes a number", isValid: text.contains(where: { $0.isNumber })),
    ///             FormValidationElement(message: "Password includes a special character", isValid: text.contains(where: { "!@#$%^&*()".contains($0) }))
    ///         ]
    ///     }
    /// ```
    /// This example shows how to provide detailed feedback on password strength, checking for length, inclusion of numbers, and special characters.
    public func onFormValidate(formValidationHandler: @escaping (String) -> [ValidationTextField.FormValidationElement]) -> some View {
        environment(\.formValidationHandler, formValidationHandler)
    }
    
    
    /// Applies a glowing effect to any SwiftUI view using a specified color and intensity.
    ///
    /// This function enhances the view by adding a glow modifier that uses a uniform color. The intensity parameter adjusts the brightness and spread of the glow, allowing for subtle to striking visual enhancements.
    ///
    /// - Parameters:
    ///   - color: The `Color` to use for the glow effect.
    ///   - intensity: The `CGFloat` that determines the strength of the glow effect.
    ///
    /// ## Usage:
    /// ```swift
    /// Text("Glowing Text")
    ///     .glow(color: .blue, intensity: 0.5)
    /// ```
    ///
    /// - Note: This method is particularly effective for creating visually distinctive UI elements that need to stand out.
    public func glow(color: Color, intensity: CGFloat) -> some View {
        self.modifier(GlowColorView(color: color, intensity: intensity))
    }
    
    /// Applies a glowing effect to any SwiftUI view using a specified gradient and intensity.
    ///
    /// This function wraps the view with a modifier that overlays a gradient, which gives the view a glowing appearance. The intensity of the glow can be adjusted to suit different design needs.
    ///
    /// - Parameters:
    ///   - gradient: A `LinearGradient` defining the colors of the glow.
    ///   - intensity: A `CGFloat` that determines the strength of the glow effect.
    ///
    /// ## Usage:
    /// ```swift
    /// Text("Glowing Text")
    ///     .glow(gradient: LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom), intensity: 0.6)
    /// ```
    ///
    /// - Note: This method is useful for adding attention-grabbing highlights to elements of your UI.
    public func glow(gradient: LinearGradient, intensity: CGFloat) -> some View {
        self.modifier(GlowGradientView(gradient: gradient, intensity: intensity))
    }
    
}

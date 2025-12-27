//
//  ValidationTextField.swift
//  CommonSwiftUI
//
//  Created by James Thang on 08/06/2024.
//

import SwiftUI

/// A SwiftUI view that provides a text field with extensive validation capabilities, including secure text entry.
///
/// `ValidationTextField` allows visual feedback and validation for user inputs, suitable for both standard and secure text fields. It supports environmental properties to customize behavior and appearance based on validation results.
///
/// - Parameters:
///   - title: The label text for the text field.
///   - text: A binding to the user input text.
///   - isValidBinding: A binding reflecting the current validation state.
///   - isSecured: Indicates if the text field should obscure text input.
///   - config: Configuration for visual properties like border and validation message styles.
///
/// ## Modifiers:
/// - `clearButtonHidden`: Controls visibility of the clear button.
/// - `secureButtonHidden`: Controls visibility of the secure text toggle button.
/// - `isMandatory`: Marks the field as required and provides a custom message if validation fails.
/// - `onValidate`: Adds custom validation logic for the text field.
/// - `onFormValidate`: Handles form-level validation by providing an array of validation results.
///
/// ## Usage Example:
/// ```swift
/// struct ContentView: View {
///     enum FocusableField: Hashable {
///         case firstName, lastName, address, password, strongPassword
///     }
///
///     enum TextFieldError: LocalizedError {
///         case weakPassword
///         var errorDescription: String? {
///             switch self {
///             case .weakPassword:
///                 return "Password has to be at least 6 characters long."
///             }
///         }
///     }
///
///     @State private var firstName = ""
///     @State private var lastName = ""
///     @State private var address = ""
///     @State private var password = ""
///     @State private var strongPassword = ""
///     @State private var isFormFirstNameValid = false
///     @State private var isFormLastNameValid = false
///     @State private var isPasswordValid = false
///     @State private var isStrongPasswordValid = false
///     @FocusState private var focus: FocusableField?
///
///     var body: some View {
///         VStack(spacing: 15) {
///             ValidationTextField(title: "First Name", text: $firstName, isValid: $isFormFirstNameValid)
///                 .autocorrectionDisabled()
///                 .focused($focus, equals: .firstName)
///                 .isMandatory(true)
///
///             ValidationTextField(title: "Last Name", text: $lastName, isValid: $isFormLastNameValid)
///                 .focused($focus, equals: .lastName)
///                 .isMandatory(true)
///
///             ValidationTextField(title: "Address", text: $address)
///                 .clearButtonHidden(true)
///                 .focused($focus, equals: .address)
///
///             ValidationTextField(title: "Password", text: $password, isValid: $isPasswordValid, isSecured: true)
///                 .focused($focus, equals: .password)
///                 .isMandatory(true)
///                 .secureTextButtonHidden(false)
///                 .onValidate { value in
///                     value.count >= 6 ? .success("Good Password") : .failure(TextFieldError.weakPassword)
///                 }
///
///             ValidationTextField(title: "Strong Password", text: $strongPassword, isValid: $isStrongPasswordValid, isSecured: true)
///                 .focused($focus, equals: .strongPassword)
///                 .isMandatory(true)
///                 .secureTextButtonHidden(false)
///                 .onFormValidate { text in
///                     let atLeast6Char = text.count >= 6
///                     let containNumbers = text.rangeOfCharacter(from: .decimalDigits) != nil
///                     let containPunctuation = text.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#%^&")) != nil
///                     return [
///                         .init(message: atLeast6Char ? "Password is at least 6 characters" : "Password needs to be at least 6 characters", isValid: atLeast6Char),
///                         .init(message: containNumbers ? "Password contains number" : "Password needs to contain number", isValid: containNumbers),
///                         .init(message: containPunctuation ? "Password contains special character !@#%^&" : "Password needs to contain special character !@#%^&", isValid: containPunctuation)
///                     ]
///                 }
///
///             Spacer()
///
///             Button("Submit") {
///                 // Handle submission logic
///             }
///             .disabled(!(isFormFirstNameValid && isFormLastNameValid && isPasswordValid && isStrongPasswordValid))
///         }
///         .padding()
///     }
/// }
/// ```
///
/// This example effectively demonstrates how to configure and use `ValidationTextField` for a form handling multiple fields, ensuring that all entries meet specified validation criteria before enabling form submission.
///
public struct ValidationTextField: View {
    
    private var title: String
    @State private var isSecured: Bool = false
    private var config: ValidationTextField.Config = .init()
    @Binding private var text: String
    @Binding private var isValidBinding: Bool
    
    @Environment(\.clearButtonHidden) var clearButtonHidden
    @Environment(\.secureButtonHidden) var secureButtonHidden
    @Environment(\.isMandatory) var isMandatory
    @Environment(\.validationHandler) var validationHandler
    @Environment(\.formValidationHandler) var formValidationHandler
    
    @State private var isValid: Bool = true {
        didSet {
            isValidBinding = isValid
        }
    }
    @State private var validationMessage: String = ""
    @State private var formValidationResult: [ValidationTextField.FormValidationElement] = []
    
    private func validate(_ value: String) {
        if isMandatory.0 {
            isValid = !value.isEmpty
            validationMessage = isValid ? "" : isMandatory.1
        }
        
        if isValid {
            // onValidate
            if let validationHandler {
                let validationResult = validationHandler(value)
                if case .failure(let error) = validationResult {
                    isValid = false
                    self.validationMessage = "\(error.localizedDescription)"
                } else if case .success(let validMessage) = validationResult {
                    self.isValid = true
                    self.validationMessage = validMessage
                }
            }
            
            // onFormValidate
            if let formValidationHandler {
                formValidationResult = formValidationHandler(value)
                isValid = formValidationResult.allSatisfy { $0.isValid }
            }
        }
    }
    
    public init(title: String, text: Binding<String>, isValid isValidBinding: Binding<Bool>? = nil, isSecured: Bool = false, config: ValidationTextField.Config = .init()) {
        self.title = title
        self._text = text
        self._isValidBinding = isValidBinding ?? .constant(true)
        self.isSecured = isSecured
        self.config = config
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(text.isEmpty ? .secondary : .primary)
                    .offset(x: text.isEmpty ? 0 : -15, y: text.isEmpty ? 0 : -44)
                    .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
                
                Group {
                    if isSecured {
                        SecureField("", text: $text)
                    } else {
                        TextField("", text: $text)
                    }
                }
                .padding(.trailing, 20)
                .overlay(alignment: .trailing) {
                    HStack {
                        secureButton
                        clearButton
                    }
                }
                .onAppear {
                    validate(text)
                }
                .onChange(of: text) { newValue in
                    validate(newValue)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: config.borderConfig.radius)
                    .stroke(isValid ? config.borderConfig.validColor : config.borderConfig.invalidColor, lineWidth: config.borderConfig.width)
            }
            
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .foregroundStyle(isValid ? config.messageConfig.correctValidationColor : config.messageConfig.errorValidationColor)
                    .scaleEffect(0.8, anchor: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if !formValidationResult.isEmpty {
                ForEach(formValidationResult, id: \.id) { validationMessage in
                    VStack(alignment: .leading) {
                        if !validationMessage.message.isEmpty {
                            Text(validationMessage.message)
                                .foregroundStyle(validationMessage.isValid ? config.messageConfig.correctValidationColor : config.messageConfig.errorValidationColor)
                                .scaleEffect(0.8, anchor: .leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
        }
        .padding(.top, 15)
        .animation(.default, value: text)
    }
    
    private var clearButton: some View {
        HStack {
            if !clearButtonHidden {
                Button(action: {
                    text = ""
                }, label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundStyle(.gray)
                })
            } else {
                EmptyView()
            }
        }
    }
    
    private var secureButton: some View {
        HStack {
            if !secureButtonHidden {
                Button(action: {
                    isSecured.toggle()
                }, label: {
                    Image(systemName: isSecured ? "eye" : "eye.slash.fill")
                        .foregroundStyle(.gray)
                })
            } else {
                EmptyView()
            }
        }
    }
    
    /// Configuration settings for the `ValidationTextField`.
    ///
    /// Allows customization of text field validation appearance and behavior.
    ///
    /// - Parameters:
    ///   - messageConfig: Settings for the appearance of validation messages.
    ///   - borderConfig: Styling options for the text field border.
    public struct Config {
        private(set) var messageConfig: ValidationTextField.MessageConfig
        private(set) var borderConfig: ValidationTextField.BorderConfig
        
        public init(messageConfig: ValidationTextField.MessageConfig = .init(), borderConfig: ValidationTextField.BorderConfig = .init()) {
            self.messageConfig = messageConfig
            self.borderConfig = borderConfig
        }
    }
    
    /// Configures the appearance of validation messages within `ValidationTextField`.
    ///
    /// - Parameters:
    ///   - correctValidationColor: The color used for the message when the input is valid.
    ///   - errorValidationColor: The color used for the message when the input is invalid.
    public struct MessageConfig {
        private(set) var correctValidationColor: Color
        private(set) var errorValidationColor: Color
        
        public init(correctValidationColor: Color = .green, errorValidationColor: Color = .red) {
            self.correctValidationColor = correctValidationColor
            self.errorValidationColor = errorValidationColor
        }
    }
    
    /// Configures the border appearance for `ValidationTextField`.
    ///
    /// - Parameters:
    ///   - show: Determines if the border should be visible.
    ///   - validColor: The border color when the input is valid.
    ///   - invalidColor: The border color when the input is invalid.
    ///   - radius: The corner radius of the border.
    ///   - width: The thickness of the border.
    public struct BorderConfig {
        private(set) var show: Bool
        private(set) var validColor: Color
        private(set) var invalidColor: Color
        private(set) var radius: CGFloat
        private(set) var width: CGFloat
        
        public init(show: Bool = true, validColor: Color = .primary, invalidColor: Color = .red, radius: CGFloat = 8, width: CGFloat = 1.0) {
            self.show = show
            self.validColor = validColor
            self.invalidColor = invalidColor
            self.radius = radius
            self.width = width
        }
    }
    
    /// Represents an element of form validation, encapsulating a validation message and its associated validation state.
    ///
    /// `FormValidationElement` is used to provide detailed feedback for each validation rule within a form, helping to inform the user about the specific requirements that are met or need attention.
    ///
    /// - Properties:
    ///   - id: A unique identifier for the validation element, facilitating tracking and updates within a dynamic interface.
    ///   - message: A descriptive message related to the validation rule, indicating whether the input meets specific criteria.
    ///   - isValid: A Boolean value indicating whether the input satisfies the validation condition associated with this element.
    ///
    /// ## Example:
    /// ```swift
    /// .onFormValidate { text in
    ///     [
    ///         FormValidationElement(message: "Password is at least 6 characters", isValid: text.count >= 6),
    ///         FormValidationElement(message: "Password contains a number", isValid: text.rangeOfCharacter(from: .decimalDigits) != nil),
    ///         FormValidationElement(message: "Password contains a special character", isValid: text.contains(where: { "!@#$%^&*()".contains($0) }))
    ///     ]
    /// }
    /// ```
    /// This structure provides a flexible way to manage and display validation results for complex forms, enabling tailored feedback for each rule.
    public struct FormValidationElement: Identifiable {
        private(set) public var id: UUID
        private(set) var message: String
        private(set) var isValid: Bool
        
        public init(message: String, isValid: Bool) {
            self.id = .init()
            self.message = message
            self.isValid = isValid
        }
    }
    
}

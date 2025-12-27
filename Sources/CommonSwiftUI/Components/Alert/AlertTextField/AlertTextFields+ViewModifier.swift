//
//  AlertTextField.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/03/2024.
//

import UIKit
import SwiftUI

/// Represents a configurable text field for use within an alert dialog.
///
/// This structure allows for the creation of a text field with customizable properties such as placeholder text, keyboard type, secure text entry for passwords, and text capitalization behavior. It can be used to gather input from users in a variety of contexts, ensuring that the text field is tailored to the specific type of data being requested.
///
/// - Parameters:
///   - placeholder: A `String` that appears in the text field when it's empty, hinting at the expected input.
///   - keyboardType: The type of keyboard to display. Defaults to `.default`.
///   - isSecureTextEntry: A `Bool` indicating whether the text field is for secure text entry (e.g., passwords). Defaults to `false`.
///   - autocapitalizationType: The autocapitalization strategy for the text field. Defaults to `.none`.
public struct AlertTextField {
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isSecureTextEntry: Bool
    let autocapitalizationType: UITextAutocapitalizationType
    
    public init(placeholder: String, keyboardType: UIKeyboardType = .default, isSecureTextEntry: Bool = false, autocapitalizationType: UITextAutocapitalizationType = .none) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.autocapitalizationType = autocapitalizationType
    }
}

extension View {
    /// Presents an alert with customizable text fields and actions.
    ///
    /// This function creates and displays an `UIAlertController` with a specified title and message, incorporating any number of customizable text fields and actions. Each text field can be tailored with specific attributes like placeholders and keyboard types, while actions can define their title, style, and a completion handler that processes the entered text.
    ///
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message displayed in the alert.
    ///   - textFields: An array of `AlertTextField`, configuring each text field within the alert.
    ///   - actions: An array of `AlertAction`, representing the actions that can be taken from the alert.
    ///
    /// ## Usage Example:
    /// ```swift
    /// Button(action: {
    ///     AlertWithTextFields(
    ///         title: "Login",
    ///         message: "Please enter your credentials",
    ///         textFields: [
    ///             AlertTextField(placeholder: "Username"),
    ///             AlertTextField(placeholder: "Password", isSecureTextEntry: true)
    ///         ],
    ///         actions: [
    ///             AlertAction(title: "Cancel", style: .cancel) { _ in print("Cancel") },
    ///             AlertAction(title: "Login", style: .default) { result in print("Login info: \(result)") }
    ///         ]
    ///     )
    /// }, label: {
    ///     Text("Present Alert")
    /// })
    /// ```
    /// This setup presents an alert for login, with text fields for username and password and options to cancel or log in.
    public func AlertWithTextFields(
        title: String,
        message: String,
        textFields: [AlertTextField],
        actions: [AlertAction]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for alertTextField in textFields {
            alert.addTextField { textField in
                textField.placeholder = alertTextField.placeholder
                textField.keyboardType = alertTextField.keyboardType
                textField.isSecureTextEntry = alertTextField.isSecureTextEntry
                textField.autocapitalizationType = alertTextField.autocapitalizationType
            }
        }
        
        for action in actions {
            alert.addAction(.init(title: action.title, style: action.style, handler: { _ in
                if let alertTextFields = alert.textFields {
                    var result = [String]()
                    for alertTextField in alertTextFields {
                        result.append(alertTextField.text ?? "")
                    }
                    action.completion(result)
                } else {
                    action.completion([""])
                }
            }))
        }
        
        UIApplication.rootViewController.present(alert, animated: true, completion: nil)
    }
}

//
//  AlertAction.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/03/2024.
//

import UIKit

/// Defines an action for an alert dialog.
///
/// This structure encapsulates the information needed to present an action within an alert, including the action's title, its visual style, and a completion handler that executes when the action is selected. The completion handler passes back an array of strings, allowing for flexible use cases such as returning input from text fields within the alert.
///
/// - Parameters:
///   - title: The text to display on the action button.
///   - style: The visual style of the action, defined by `UIAlertAction.Style`.
///   - completion: A closure that is called when the action is selected, passing an array of `String` as its parameter.
public struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let completion: ([String]) -> ()
        
    public init(title: String, style: UIAlertAction.Style, completion: @escaping ([String]) -> ()) {
        self.title = title
        self.style = style
        self.completion = completion
    }
}

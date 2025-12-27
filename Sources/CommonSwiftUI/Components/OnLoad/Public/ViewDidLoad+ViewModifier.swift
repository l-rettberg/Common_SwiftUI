//
//  ViewDidLoad+ViewModifier.swift
//  CommonSwiftUI
//
//  Created by James Thang on 18/06/2024.
//

import SwiftUI

extension View {
    /// Attaches a callback that performs an action when the view loads.
    ///
    /// This function allows for executing code at the moment the view is first rendered. It's useful for initiating data fetching, analytics, or other one-time setup tasks when a view appears.
    ///
    /// - Parameter action: An optional closure to perform when the view loads. If nil, no action is taken.
    ///
    /// ## Usage:
    /// ```swift
    /// Text("Welcome")
    ///     .onLoad {
    ///         print("View has loaded")
    ///     }
    /// ```
    /// This example prints a message to the console when the `Text` view loads.
    public func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

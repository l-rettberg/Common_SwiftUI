//
//  Toast.swift
//  Toasting
//
//  Created by James Thang on 17/12/2023.
//

import SwiftUI
import Combine

/// A singleton class responsible for managing toast notifications within an application.
///
/// `Toast` provides functionality to present and remove toast messages. It uses an observable object pattern to update UI components when toasts are added or removed.
///
/// - Note: Access the shared instance with `Toast.shared`.
///
/// Usage for presenting a toast:
/// ```swift
/// Button("Show Toast") {
///     Toast.shared.present(
///         title: "Hello",
///         symbol: "hand.wave",
///         tint: .blue,
///         isUserInteractionEnabled: true,
///         timing: .long
///     )
/// }
/// ```
///
/// Only one instance of this class should be used (singleton pattern). This ensures toast management is centralized.
public final class Toast: ObservableObject {
    public static let shared = Toast()
    @Published private(set) var toasts: [ToastItem] = []
    
    private init() { }
    
    /// Presents a toast message with customizable options.
    ///
    /// This function creates and displays a toast with specified text, icon symbol, tint color, interaction behavior, and display duration.
    ///
    /// - Parameters:
    ///   - title: The text to display in the toast.
    ///   - symbol: An optional symbol to display alongside the text. Defaults to nil.
    ///   - tint: The color of the text and symbol. Defaults to `.primary`.
    ///   - isUserInteractionEnabled: A Boolean value that determines whether the toast allows user interaction. Defaults to false.
    ///   - timing: The duration for which the toast should remain on screen. Defaults to `.medium`.
    ///   - presentationStyle: Where the toast appears (top-down or bottom-up). Defaults to `.topDown`.
    ///
    /// ## Usage:
    /// ```swift
    /// Button("Show Toast") {
    ///     Toast.shared.present(
    ///         title: "Hello",
    ///         symbol: "hand.wave",
    ///         tint: .blue,
    ///         isUserInteractionEnabled: true,
    ///         timing: .long
    ///     )
    /// }
    /// // From bottom:
    /// Toast.shared.present(title: "Done", symbol: nil, presentationStyle: .bottomUp)
    /// ```
    public func present(title: String, symbol: String? = nil, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: Speed = .medium, presentationStyle: ToastPresentationStyle = .topDown) {
        withAnimation(.snappy) {
            toasts.append(.init(title: title, symbol: symbol, tint: tint, isUserInteractionEnabled: isUserInteractionEnabled, timing: timing, presentationStyle: presentationStyle))
        }
    }
    
    func remove(id: UUID) {
        toasts.removeAll { $0.id == id }
    }
}

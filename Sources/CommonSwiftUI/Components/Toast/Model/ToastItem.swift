//
//  ToastModel.swift
//  Toasting
//
//  Created by James Thang on 17/12/2023.
//

import SwiftUI

/// Style for where and how the toast appears on screen.
public enum ToastPresentationStyle: Sendable {
    /// Toast appears from the top and slides down. Default.
    case topDown
    /// Toast appears from the bottom and slides up.
    case bottomUp
}

struct ToastItem: Identifiable {
    let id: UUID = .init()
    // Custom Properties
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    // Timing
    var timing: Speed = .medium
    /// Where the toast is presented. Defaults to `.topDown`.
    var presentationStyle: ToastPresentationStyle = .topDown
}

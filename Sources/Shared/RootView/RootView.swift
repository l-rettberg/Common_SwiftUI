//
//  RootView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 22/03/2024.
//

import SwiftUI

/// A view container that serves as the root of a view hierarchy and can display an overlay window.
///
/// `RootView` is designed to embed any SwiftUI view and has the capability to present additional content in an overlay window on top of the existing UI. This is particularly useful for displaying elements like toasts or alerts that should float above all other content.
///
/// - Parameters:
///   - content: A closure returning the content of the view.
///
/// ## Usage:
/// ```swift
/// RootView {
///     // Your main content here
/// }
/// ```
///
/// On appear, `RootView` automatically checks for an existing overlay window and, if none is found, creates and displays a new one, allowing for content like `Toast` or `Alert` to be shown on top of the primary view hierarchy.
public struct RootView<Content: View>: View {
    var content: Content
    @StateObject private var viewModel = RootViewModel()
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        content
            .environmentObject(viewModel)
            .onAppear {
                viewModel.setupAlertWindow()
                viewModel.setupToastWindow()
            }
            .onDisappear {
                viewModel.cleanupAlertWindow()
                viewModel.cleanupToastWindow()
            }
    }

}

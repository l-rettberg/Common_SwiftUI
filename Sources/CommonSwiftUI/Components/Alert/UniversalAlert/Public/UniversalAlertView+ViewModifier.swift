//
//  UniversalAlertView+ViewModifier.swift
//  CommonSwiftUI
//
//  Created by James Thang on 17/06/2024.
//

import SwiftUI

extension View {
    /// This method enables the presentation of a customizable alert over the existing view content, using specified configurations and a custom view builder for the alert's content. It employs the `UniversalAlertModifier` to manage the presentation state and styling based on the provided `UniversalAlertConfig`.
    ///
    /// - Parameters:
    ///   - alertConfig: A binding to the `UniversalAlertConfig` instance which controls the appearance and behavior of the alert.
    ///   - content: A view builder that generates the content to be displayed in the alert. This allows for full customization of the alert's appearance and the interactive elements within it.
    ///
    /// ## Example Usage:
    /// ```swift
    /// struct ContentView: View {
    ///     // View Properties
    ///     @State private var alert: UniversalAlertConfig = .init(enableBackgroundBlur: true, disableOutsideTap: false)
    ///
    ///     var body: some View {
    ///         Button("Show Alert") {
    ///             alert.present()
    ///         }
    ///         .alert(alertConfig: $alert) {
    ///             VStack {
    ///                 Spacer()
    ///
    ///                 RoundedRectangle(cornerRadius: 15)
    ///                     .fill(.red)
    ///                     .frame(width: 150, height: 150, alignment: .bottom)
    ///                     .foregroundStyle(.yellow)
    ///                     .onTapGesture {
    ///                         alert.dismiss()
    ///                     }
    ///             }
    ///             .frame(maxWidth: .infinity, maxHeight: .infinity)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// In this example, a button triggers the presentation of a customizable alert, which includes a sizable red rectangle. A tap on the rectangle will dismiss the alert. The `alertConfig` is set to enable background blur and allows tap interactions outside the alert area.
    ///
    /// Use this extension to seamlessly integrate custom alerts into any SwiftUI view, enhancing user interaction and providing a dynamic and adaptable alerting solution.
    @ViewBuilder
    public func alert<Content: View>(alertConfig: Binding<UniversalAlertConfig>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .modifier(UniversalAlertModifier(config: alertConfig, alertContent: content))
    }
}

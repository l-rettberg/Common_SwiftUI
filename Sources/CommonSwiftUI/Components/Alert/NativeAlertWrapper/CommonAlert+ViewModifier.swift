//
//  CommonAlert.swift
//  CommonSwiftUI
//
//  Created by James Thang on 24/03/2024.
//

import Foundation
import SwiftUI

/// Defines the structure for common alert components within the application.
///
/// This protocol standardizes the way alerts are created by specifying essential elements that each alert should contain. Conforming to this protocol ensures consistency in alert presentation and functionality.
///
/// - Properties:
///   - title: The primary text displayed in the alert, typically used for summarizing the alert's purpose.
///   - subTitle: An optional secondary text providing additional details or context.
///   - buttons: A view component representing the actionable items or responses available for the alert.
///
///   Adopting the `CommonAlert` component helps projects by standardizing alert presentations across an application, ensuring a consistent user interface.
///
///   This consistency can reduce development time and errors by providing a unified method for creating and managing alerts. By conforming to the CommonAlert protocol, developers can customize alert components while maintaining a coherent appearance and functionality.
///
///   This modularity and consistency in design make the component particularly useful in large projects or those requiring frequent alert updates.
///
public protocol CommonAlert {
    var title: String { get }
    var subTitle: String? { get }
    var buttons: AnyView { get }
}

extension View {
    /// Presents a customizable alert using the provided `CommonAlert` conforming data.
    ///
    /// This function displays an alert based on the properties defined in an instance of `T`, where `T` conforms to the `CommonAlert` protocol. It allows for dynamic alert content including title, subtitle, and custom button actions.
    ///
    /// - Parameter alert: A binding to an optional `CommonAlert` conforming object that provides the data for the alert.
    ///
    /// ## Usage:
    /// Pass a binding to your custom alert conforming to `CommonAlert` to this function to display it.
    public func showCustomAlert<T: CommonAlert>(alert: Binding<T?>) -> some View {
        self.alert(alert.wrappedValue?.title ?? "Error", isPresented: Binding(value: alert)) {
            alert.wrappedValue?.buttons
        } message: {
            if let subTitle = alert.wrappedValue?.subTitle {
                Text(subTitle)
            }
        }
    }
}

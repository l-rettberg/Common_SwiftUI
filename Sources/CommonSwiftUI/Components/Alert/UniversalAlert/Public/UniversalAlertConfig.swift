//
//  UniversalAlertConfig.swift
//  CommonSwiftUI
//
//  Created by James Thang on 17/06/2024.
//

import SwiftUI

/// `UniversalAlertConfig` configures the presentation and behavior of a customizable alert view in a SwiftUI application.
///
/// This configuration struct allows you to customize alert presentations with various properties such as background blur, disable interactions outside the alert, and choose from different transition animations.
///
/// ## Properties:
/// - `enableBackgroundBlur`: A Boolean value that determines whether the background should be blurred when the alert is presented.
/// - `disableOutsideTap`: A Boolean value that if set to true, disables dismissing the alert by tapping outside its bounds.
/// - `transitionType`: The type of transition animation used when the alert is presented. Can be either `.slide` or `.opacity`.
/// - `slideEdge`: The edge from which the alert should slide in if the transition type is `.slide`.
/// - `show`: A Boolean value indicating whether the alert is currently presented.
///
/// ## Methods:
/// - `present()`: Sets the `show` property to true to present the alert.
/// - `dismiss()`: Sets the `show` property to false to dismiss the alert.
///
/// ## Initialization:
/// Initializes a new configuration with optional parameters for background blur, outside tap behavior, transition type, and slide edge.
///
/// Use this struct to manage the presentation states and styles of alerts, providing a flexible and dynamic user interface component suitable for various alerting needs.
///
public struct UniversalAlertConfig {
    
    private(set) var enableBackgroundBlur: Bool
    private(set) var disableOutsideTap: Bool
    private(set) var transitionType: TransitionType
    private(set) var slideEdge: Edge
    private(set) var show: Bool = false
    var showView: Bool = false
    
    public init(enableBackgroundBlur: Bool = false, disableOutsideTap: Bool = false, transitionType: TransitionType = .slide, slideEdge: Edge = .bottom) {
        self.enableBackgroundBlur = enableBackgroundBlur
        self.disableOutsideTap = disableOutsideTap
        self.transitionType = transitionType
        self.slideEdge = slideEdge
    }
    
    /// An enumeration representing the transition animation types for presenting alerts in the `UniversalAlertConfig`.
    ///
    /// This enum specifies the different animations that can be used to present the alert, allowing for a customizable appearance when the alert is shown or dismissed.
    ///
    /// - Cases:
    ///   - slide: Represents a sliding transition where the alert enters and exits from a specified edge of the screen. This transition type provides a dynamic, directional animation that can be aligned with the user interface's flow.
    ///   - opacity: Represents a fade-in and fade-out transition. This transition type offers a subtle appearance and disappearance of the alert, creating a smoother visual effect.
    ///
    /// ## Example Usage:
    /// To use the `TransitionType`, specify it when initializing an instance of `UniversalAlertConfig`:
    /// ```swift
    /// var alertConfig = UniversalAlertConfig(transitionType: .opacity)
    /// ```
    ///
    /// The choice of transition type affects the visual dynamics of the alert presentation, enhancing the user interaction experience based on the context.
    public enum TransitionType {
        case slide
        case opacity
    }
    
    public mutating func present() {
        show = true
    }
    
    public mutating func dismiss() {
        show = false
    }
    
}

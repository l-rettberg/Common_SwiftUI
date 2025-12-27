//
//  HapticController.swift
//  CommonSwiftUI
//
//  Created by James Thang on 10/10/2024.
//

import UIKit

/// Manages haptic feedback interactions in an application.
///
/// This class provides a singleton instance to manage haptic feedback via various types of vibrations. It allows for selection, notification, and impact haptic feedbacks.
///
/// ## Methods:
/// - `vibrateForSelection()`: Triggers a light haptic feedback ideal for selection changes.
/// - `vibrate(for type: UINotificationFeedbackGenerator.FeedbackType)`: Triggers haptic feedback corresponding to various notification types like success, warning, or error.
/// - `vibrateForImpact(style: UIImpactFeedbackGenerator.FeedbackStyle)`: Triggers haptic feedback for physical impacts ranging from light to heavy.
///
/// The `HapticController` utilizes the system's built-in feedback generators to manage these interactions.
///
/// ## Example:
/// ```swift
/// // To trigger a selection feedback:
/// HapticController.shared.vibrateForSelection()
///
/// // To trigger an error notification feedback:
/// HapticController.shared.vibrate(for: .error)
///
/// // To trigger a heavy impact feedback:
/// HapticController.shared.vibrateForImpact(style: .heavy)
/// ```
/// These methods should be called when the user interacts with the UI in a way that feedback is meaningful.
public final class HapticController {
    
    public static let shared = HapticController()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private var impactGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    
    private init() {}
    
    public func vibrateForSelection() {
        // Vibrate lightly for a selection tap interaction
        selectionGenerator.prepare()
        selectionGenerator.selectionChanged()
    }
    
    // Vibrate for type
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }
    
    public func vibrateForImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        // Retrieve or create the generator for the specified style
        let generator: UIImpactFeedbackGenerator
        if let existingGenerator = impactGenerators[style] {
            generator = existingGenerator
        } else {
            generator = UIImpactFeedbackGenerator(style: style)
            impactGenerators[style] = generator
        }
        
        generator.prepare()
        generator.impactOccurred()
    }
    
}

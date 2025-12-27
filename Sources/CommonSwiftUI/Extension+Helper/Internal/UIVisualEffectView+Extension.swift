//
//  UIVisualEffectView+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 28/03/2024.
//

import UIKit

extension UIVisualEffectView {
    
    var backDrop: UIView? {
        // Private Class
        return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    
    // Extracting Gaussian Blur from BackdropView
    var gaussianBlur: NSObject? {
        return backDrop?.value(key: "filters", filter: "gaussianBlur")
    }
    
    // extracting Saturation from BackdropView
    var saturation: NSObject? {
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }
    
    // Updating Blur Radius and Saturation
    var gaussianBlurRadius: CGFloat {
        get {
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
        }
        set {
            gaussianBlur?.values?["inputRadius"] = newValue
            // Updating the Backdrop View with the new Filter Updates
            applyNewEffects()
        }
    }
    
    func applyNewEffects() {
        UIVisualEffectView.animate(withDuration: 0.5) {
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
        }
    }
    
    
    var saturationAmount: CGFloat {
        get {
            return saturation?.values?["inputAmount"] as? CGFloat ?? 0
        }
        set {
            saturation?.values?["inputAmount"] = newValue
            applyNewEffects()
        }
    }
    
}

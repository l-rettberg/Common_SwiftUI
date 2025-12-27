//
//  UIScreen+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 23/08/2024.
//

import UIKit

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

//
//  UIView+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 28/03/2024.
//

import UIKit

extension UIView {
    func subView(forClass: AnyClass?) -> UIView? {
        return subviews.first { view in
            type(of: view) == forClass
        }
    }
}

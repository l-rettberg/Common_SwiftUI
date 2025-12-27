//
//  Binding+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 24/03/2024.
//

import Foundation
import SwiftUI

extension Binding where Value == Bool {
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}

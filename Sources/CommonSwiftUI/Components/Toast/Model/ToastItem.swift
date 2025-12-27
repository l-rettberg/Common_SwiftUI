//
//  ToastModel.swift
//  Toasting
//
//  Created by James Thang on 17/12/2023.
//

import SwiftUI

struct ToastItem: Identifiable {
    let id: UUID = .init()
    // Custom Properties
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    // Timing
    var timing: Speed = .medium
}

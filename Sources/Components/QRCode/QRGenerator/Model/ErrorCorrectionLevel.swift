//
//  ErrorCorrectionLevel.swift
//  CommonSwiftUI
//
//  Created by James Thang on 18/09/2024.
//

import Foundation

/// Represents the error correction levels for a QR code.
/// Low error correction level (7% recovery).
/// Medium error correction level (15% recovery).
/// Quartile error correction level (25% recovery).
/// High error correction level (30% recovery).
///
public enum ErrorCorrectionLevel: String {
    case low = "L"
    case medium = "M"
    case quartile = "Q"
    case high = "H"
}

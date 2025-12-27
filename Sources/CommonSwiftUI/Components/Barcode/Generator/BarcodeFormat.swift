//
//  BarcodeFormat.swift
//  CommonSwiftUI
//
//  Created by James Thang on 21/09/2024.
//

import Foundation

/// An enumeration of supported barcode formats for generation.
///
/// The `BarcodeFormat` enum defines the various barcode types that can be generated using the `BarcodeGenerator`.
/// Each case corresponds to a specific barcode format supported by Core Image, along with its associated Core Image filter.
///
/// - Supported Formats:
///   - **Code 128**: A high-density linear barcode format that can encode a large number of characters.
///   - **PDF417**: A stacked linear barcode format used in a variety of applications, including transport and identification.
///   - **Aztec**: A 2D barcode format known for its compact size and error correction capabilities, often used in mobile ticketing.
///   - **QR Code**: A widely used 2D barcode format capable of encoding various types of data, including URLs and text.
///
public enum BarcodeFormat {
    
    /// Represents the Code 128 barcode format, a high-density linear barcode.
    ///
    /// **Description:**
    /// Code 128 is a versatile barcode symbology that can encode a wide range of characters, including all 128 ASCII characters.
    /// It is commonly used in shipping and packaging industries due to its compact size and high data density.
    case code128
    
    /// Represents the PDF417 barcode format, a stacked linear barcode format used in various applications.
    ///
    /// **Description:**
    /// PDF417 is a two-dimensional barcode format that can encode a significant amount of data, including text, numbers, and binary data.
    /// It is widely used in transport (e.g., airline boarding passes), identification cards, and inventory management systems.
    case pdf417
    
    /// Represents the Aztec barcode format, a 2D barcode with a compact square design.
    ///
    /// **Description:**
    /// Aztec codes are known for their ability to encode large amounts of data in a small space. They feature a central bullseye pattern
    /// that facilitates easy scanning, even in poor lighting conditions. Aztec codes are commonly used in mobile ticketing and transportation.
    case aztec
    
    /// Represents the QR Code barcode format, a widely used 2D barcode for encoding information such as URLs.
    ///
    /// **Description:**
    /// QR (Quick Response) Codes are among the most recognizable barcode formats today. They can store various types of information, including
    /// URLs, contact information, and plain text. QR Codes are extensively used in marketing, mobile payments, and information sharing.
    case qrCode
    
    var filterName: String {
        switch self {
        case .code128:
            return "CICode128BarcodeGenerator"
        case .pdf417:
            return "CIPDF417BarcodeGenerator"
        case .aztec:
            return "CIAztecCodeGenerator"
        case .qrCode:
            return "CIQRCodeGenerator"
        }
    }
    
    // Description for each format to display in the UI
    public var description: String {
        switch self {
        case .code128:
            return "Code 128"
        case .pdf417:
            return "PDF417"
        case .aztec:
            return "Aztec"
        case .qrCode:
            return "QR Code"
        }
    }
    
    // Boolean to indicate if the format is 2D or 1D
    public var is2D: Bool {
        switch self {
        case .pdf417, .aztec, .qrCode:
            return true // These are 2D formats
        case .code128:
            return false // These are 1D formats
        }
    }
    
}


//
//  BarcodeGenerationError.swift
//  CommonSwiftUI
//
//  Created by James Thang on 22/09/2024.
//

import Foundation

/// An enumeration of errors that can occur during barcode generation.
///
/// This enum defines the different failure scenarios that might be encountered when generating barcodes
/// using the `BarcodeGenerator`. Each case represents a specific type of error.
///
/// - Note: This enum conforms to `LocalizedError` to provide descriptive error messages suitable for user interfaces.
public enum BarcodeGenerationError: Error {
    case invalidFilter
    case invalidInputData
    case outputImageGenerationFailed
    case cgImageCreationFailed
}

extension BarcodeGenerationError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidFilter:
            return NSLocalizedString("The specified barcode format is invalid or unsupported.", comment: "Invalid Filter Error")
        case .invalidInputData:
            return NSLocalizedString("The input data is invalid or cannot be processed.", comment: "Invalid Input Data Error")
        case .outputImageGenerationFailed:
            return NSLocalizedString("Failed to generate the barcode image.", comment: "Output Image Generation Error")
        case .cgImageCreationFailed:
            return NSLocalizedString("Failed to create a CGImage from the generated barcode.", comment: "CGImage Creation Error")
        }
    }
    
}

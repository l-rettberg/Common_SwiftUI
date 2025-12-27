//
//  QRCodeGenerationError.swift
//  CommonSwiftUI
//
//  Created by James Thang on 18/09/2024.
//

import Foundation

/// Represents errors that can occur during QR code generation.
///
/// - `dataConversionFailed`: Failed to convert the input string to data.
/// - `outputImageCreationFailed`: Failed to create the output image from the filter.
/// - `cgImageCreationFailed`: Failed to create the CGImage from the CIImage.
/// - `bitmapContextCreationFailed`: Failed to create the bitmap context.
/// - `finalImageCreationFailed`: Failed to create the final image from the bitmap context.
/// - `sizeTooSmall(minimumSize: CGSize)`: The requested size is too small to generate the QR code.
/// - `graphicsContextCreationFailed`: Failed to create the graphics context.
/// - `gradientCreationFailed`: Failed to create the gradient image from the graphics context.
/// - `ciImageCreationFailed`: Failed to create the CIImage from the gradient image.
/// - `blendFilterCreationFailed`: Failed to create the blended QR code image.
public enum QRCodeGenerationError: Error {

    /// Failed to convert the input string to data.
    case dataConversionFailed
    /// Failed to create the output image from the filter.
    case outputImageCreationFailed
    /// Failed to create the Core Graphics image from the CIImage.
    case cgImageCreationFailed
    /// Failed to create the bitmap context.
    case bitmapContextCreationFailed
    /// Failed to create the final image from the bitmap context.
    case finalImageCreationFailed
    /// Failed to create the final image because requested size is too small
    case sizeTooSmall(minimumSize: CGSize)
    /// Failed to create the graphics context.
    case graphicsContextCreationFailed
    /// Failed to create the gradient image from the graphics context.
    case gradientCreationFailed
    /// Failed to create the CIImage from the input image.
    case ciImageCreationFailed
    /// Failed to create the blended QR code image.
    case blendFilterCreationFailed
    
}

extension QRCodeGenerationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataConversionFailed:
            return "Failed to convert the input data."
        case .outputImageCreationFailed:
            return "Failed to create the output image from the filter."
        case .cgImageCreationFailed:
            return "Failed to create the CGImage from the CIImage."
        case .bitmapContextCreationFailed:
            return "Failed to create the bitmap context."
        case .finalImageCreationFailed:
            return "Failed to create the final image from the bitmap context."
        case .sizeTooSmall(let minimumSize):
            return "Requested size is too small. Minimum size is \(Int(minimumSize.width))x\(Int(minimumSize.height)) pixels."
        case .graphicsContextCreationFailed:
            return "Failed to create the graphics context."
        case .gradientCreationFailed:
            return "Failed to create the gradient image from the graphics context."
        case .ciImageCreationFailed:
            return "Failed to create the CIImage from the input image."
        case .blendFilterCreationFailed:
            return "Failed to create the blended QR code image."
        }
    }
}

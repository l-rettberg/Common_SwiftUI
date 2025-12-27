//
//  QRCodeGenerator+Gradient.swift
//  CommonSwiftUI
//
//  Created by James Thang on 06/10/2024.
//

import UIKit

extension QRCodeGenerator {
    
    /// Generates a gradient QR code from a string and returns an optional UIImage.
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - gradientColors: The colors to use for the gradient effect.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level for the QR code.
    /// - Returns: An optional UIImage of the QR code, `nil` if generation fails.
    public static func generateQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) -> UIImage? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return generateQRCode(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a gradient QR code from a string with customizable options and throws errors if generation fails.
    ///
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - gradientColors: An array of `UIColor` to create the gradient effect.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level for the QR code.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code with the gradient effect.
    public static func generateQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) throws -> UIImage {
        guard let data = string.data(using: .utf8) else {
            throw QRCodeGenerationError.dataConversionFailed
        }
        return try generateQRCode(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a gradient QR code from a URL and returns an optional UIImage.
    /// - Parameters:
    ///   - url: The URL to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - gradientColors: The colors to use for the gradient effect.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level for the QR code.
    /// - Returns: An optional UIImage of the QR code, `nil` if generation fails.
    public static func generateQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) -> UIImage? {
        return generateQRCode(
            from: url.absoluteString,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a gradient QR code from a URL with customizable options and throws errors if generation fails.
    ///
    /// - Parameters:
    ///   - url: The URL to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - gradientColors: An array of `UIColor` to create the gradient effect.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level for the QR code.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code with the gradient effect.
    public static func generateQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) throws -> UIImage {
        try generateQRCode(
            from: url.absoluteString,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a gradient QR code from binary data and returns an optional UIImage.
    /// - Parameters:
    ///   - data: The binary data to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - gradientColors: The colors to use for the gradient effect.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level for the QR code.
    /// - Returns: An optional UIImage of the QR code, `nil` if generation fails.
    public static func generateQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) -> UIImage? {
        generateGradientQRCodeInternal(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a gradient QR code from binary data with customizable options and throws errors if generation fails.
    ///
    /// - Parameters:
    ///   - data: The binary data to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - gradientColors: An array of `UIColor` to create the gradient effect.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level for the QR code.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code with the gradient effect.
    public static func generateQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) throws -> UIImage {
        try generateGradientQRCodeInternalThrowing(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    //MARK: - Private Utility Methods
    
    private static func generateGradientQRCodeInternal(
        from data: Data,
        size: CGSize,
        gradientColors: [UIColor],
        gradientDirection: GradientDirection,
        backgroundColor: UIColor,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) -> UIImage? {
        do {
            return try generateGradientQRCodeInternalThrowing(
                from: data,
                size: size,
                gradientColors: gradientColors,
                gradientDirection: gradientDirection,
                backgroundColor: backgroundColor,
                errorCorrectionLevel: errorCorrectionLevel
            )
        } catch {
            return nil
        }
    }
    
    private static func generateGradientQRCodeInternalThrowing(
        from data: Data,
        size: CGSize,
        gradientColors: [UIColor],
        gradientDirection: GradientDirection,
        backgroundColor: UIColor,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        try generateGradientQRCodeSharedThrowing(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            filter: .none,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
}


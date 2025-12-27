//
//  QRCodeGenerator+Color.swift
//  CommonSwiftUI
//
//  Created by James Thang on 05/10/2024.
//

import UIKit

extension QRCodeGenerator {
    
    /// Generates a QR code image from a given string.
    ///
    /// Converts the string to UTF-8 encoded data and generates a QR code image using the specified size, colors, and error correction level.
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level to use (default is `.medium`).
    /// - Returns: An optional `UIImage` containing the generated QR code.
    public static func generateQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) -> UIImage? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return generateQRCode(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from a given string.
    ///
    /// Converts the string to UTF-8 encoded data and generates a QR code image using the specified size, colors, and error correction level.
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level to use (default is `.medium`).
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code.
    public static func generateQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) throws -> UIImage {
        guard let data = string.data(using: .utf8) else {
            throw QRCodeGenerationError.dataConversionFailed
        }
        return try generateQRCode(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from a given URL.
    ///
    /// Converts the URL to a string representation and generates a QR code image using the specified size, colors, and error correction level.
    /// - Parameters:
    ///   - url: The URL to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level to use (default is `.medium`).
    /// - Returns: An optional `UIImage` containing the generated QR code.
    public static func generateQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) -> UIImage? {
        return generateQRCode(
            from: url.absoluteString,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from a given URL.
    ///
    /// Converts the URL to a string representation and generates a QR code image using the specified size, colors, and error correction level.
    /// - Parameters:
    ///   - url: The URL to encode in the QR code.
    ///   - size: The desired size of the output image (default is 300x300).
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level to use (default is `.medium`).
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code.
    public static func generateQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) throws -> UIImage {
        return try generateQRCode(
            from: url.absoluteString,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from binary data.
    ///
    /// - Parameters:
    ///   - data: The binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Returns: An optional `UIImage` containing the generated QR code.
    public static func generateQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) -> UIImage? {
        generateQRCodeInternal(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from binary data.
    ///
    /// - Parameters:
    ///   - data: The binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code.
    public static func generateQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .medium
    ) throws -> UIImage {
        return try generateQRCodeInternalThrowing(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    //MARK: - Private Utility Methods
    
    private static func generateQRCodeInternal(
        from data: Data,
        size: CGSize,
        color: UIColor,
        backgroundColor: UIColor,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) -> UIImage? {
        do {
            return try generateQRCodeInternalThrowing(
                from: data,
                size: size,
                color: color,
                backgroundColor: backgroundColor,
                errorCorrectionLevel: errorCorrectionLevel
            )
        } catch {
            return nil
        }
    }
    
    private static func generateQRCodeInternalThrowing(
        from data: Data,
        size: CGSize,
        color: UIColor,
        backgroundColor: UIColor,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        try generateQRCodeColorSharedThrowing(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            filter: .none,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
}

//
//  QRCodeGenerator+Crystallize.swift
//  CommonSwiftUI
//
//  Created by James Thang on 07/10/2024.
//

import UIKit

extension QRCodeGenerator {
    
    /// Generates a vintage-style QR code from a string.
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code pixels.
    ///   - backgroundColor: The background color of the QR code image.
    ///   - errorCorrectionLevel: QR code error correction level.
    /// - Returns: An optional `UIImage` containing the QR code if generation is successful, or `nil` if it fails.
    public static func generateVintageQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) -> UIImage? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        return generateVintageQRCode(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style QR code from a string and throws on failure.
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code pixels.
    ///   - backgroundColor: The background color of the QR code image.
    ///   - errorCorrectionLevel: QR code error correction level.
    /// - Throws: `QRCodeGenerationError` if the data conversion fails.
    /// - Returns: A `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) throws -> UIImage {
        guard let data = string.data(using: .utf8) else {
            throw QRCodeGenerationError.dataConversionFailed
        }
        
        return try generateVintageQRCode(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style QR code from a URL.
    /// - Parameters:
    ///   - url: The `URL` to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code pixels.
    ///   - backgroundColor: The background color of the QR code image.
    ///   - errorCorrectionLevel: QR code error correction level.
    /// - Returns: An optional `UIImage` containing the QR code if generation is successful, or `nil` if it fails.
    public static func generateVintageQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) -> UIImage? {
        return generateVintageQRCode(
            from: url.absoluteString,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style QR code from a URL and throws on failure.
    /// - Parameters:
    ///   - url: The `URL` to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code pixels.
    ///   - backgroundColor: The background color of the QR code image.
    ///   - errorCorrectionLevel: QR code error correction level.
    /// - Throws: `QRCodeGenerationError` if the data conversion fails.
    /// - Returns: A `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) throws -> UIImage {
        try generateVintageQRCode(
            from: url.absoluteString,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style QR code from binary data.
    /// - Parameters:
    ///   - data: Binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code pixels.
    ///   - backgroundColor: The background color of the QR code image.
    ///   - errorCorrectionLevel: QR code error correction level.
    /// - Returns: An optional `UIImage` containing the QR code if generation is successful, or `nil` if it fails.
    public static func generateVintageQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) -> UIImage? {
        do {
            return try generateCrystallizeQRCodeInternalThrowing(
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
    
    /// Generates a vintage-style QR code from binary data and throws on failure.
    /// - Parameters:
    ///   - data: Binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code pixels.
    ///   - backgroundColor: The background color of the QR code image.
    ///   - errorCorrectionLevel: QR code error correction level.
    /// - Throws: `QRCodeGenerationError` if the data conversion fails.
    /// - Returns: A `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) throws -> UIImage {
        try generateCrystallizeQRCodeInternalThrowing(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    //MARK: - Private Utility Methods
    
    private static func generateCrystallizeQRCodeInternal(
        from data: Data,
        size: CGSize,
        color: UIColor,
        backgroundColor: UIColor,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) -> UIImage? {
        do {
            return try generateCrystallizeQRCodeInternalThrowing(
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
 
    private static func generateCrystallizeQRCodeInternalThrowing(
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
            filter: .crystallize,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
}

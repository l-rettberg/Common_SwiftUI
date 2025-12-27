//
//  QRGenerator+Logo.swift
//  CommonSwiftUI
//
//  Created by James Thang on 05/10/2024.
//

import UIKit

extension QRCodeGenerator {
    
    /// Generates a QR code image from a given string, with options for colors and embedding a logo.
    ///
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - logo: An optional `UIImage` to embed at the center of the QR code.
    ///   - logoSizeRatio: The size ratio of the logo relative to the QR code size (default is 0.2, or 20%).
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Returns: A `UIImage` containing the generated QR code with the embedded logo, or nil if generation fails.
    public static func generateQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) -> UIImage? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return generateQRCode(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from a given string, with options for colors and embedding a logo.
    ///
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - logo: An optional `UIImage` to embed at the center of the QR code.
    ///   - logoSizeRatio: The size ratio of the logo relative to the QR code size (default is 0.2, or 20%).
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code with the embedded logo.
    public static func generateQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) throws -> UIImage {
        guard let data = string.data(using: .utf8) else {
            throw QRCodeGenerationError.dataConversionFailed
        }
        return try generateQRCode(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from a given URL, with options for colors and embedding a logo.
    ///
    /// - Parameters:
    ///   - url: The URL to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - logo: An optional `UIImage` to embed at the center of the QR code.
    ///   - logoSizeRatio: The size ratio of the logo relative to the QR code size (default is 0.2, or 20%).
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Returns: A `UIImage` containing the generated QR code with the embedded logo, or nil if generation fails.
    public static func generateQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) -> UIImage? {
        return generateQRCode(
            from: url.absoluteString,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from a given URL, with options for colors and embedding a logo.
    ///
    /// - Parameters:
    ///   - url: The URL to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - logo: An optional `UIImage` to embed at the center of the QR code.
    ///   - logoSizeRatio: The size ratio of the logo relative to the QR code size (default is 0.2, or 20%).
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code with the embedded logo.
    public static func generateQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) throws -> UIImage {
        return try generateQRCode(
            from: url.absoluteString,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from binary data, with options for colors and embedding a logo.
    ///
    /// - Parameters:
    ///   - data: The binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - logo: An optional `UIImage` to embed at the center of the QR code.
    ///   - logoSizeRatio: The size ratio of the logo relative to the QR code size (default is 0.2, or 20%).
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Returns: A `UIImage` containing the generated QR code with the embedded logo, or nil if generation fails.
    public static func generateQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high // Use high error correction when embedding a logo
    ) -> UIImage? {
        return generateQRCodeInternalWithLogo(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a QR code image from binary data, with options for colors and embedding a logo.
    ///
    /// - Parameters:
    ///   - data: The binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - color: The color of the QR code squares. Defaults to label color.
    ///   - backgroundColor: The background color of the QR code image. Defaults to transparent.
    ///   - logo: An optional `UIImage` to embed at the center of the QR code.
    ///   - logoSizeRatio: The size ratio of the logo relative to the QR code size (default is 0.2, or 20%).
    ///   - errorCorrectionLevel: The error correction level to use.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code with the embedded logo.
    public static func generateQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        color: UIColor = .label,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high // Use high error correction when embedding a logo
    ) throws -> UIImage {
        return try generateQRCodeInternalWithLogoThrowing(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    //MARK: - Private Utility Methods
    private static func generateQRCodeInternalWithLogo(
        from data: Data,
        size: CGSize,
        color: UIColor = .black,
        backgroundColor: UIColor,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) -> UIImage? {
        do {
            return try generateQRCodeInternalWithLogoThrowing(
                from: data,
                size: size,
                color: color,
                backgroundColor: backgroundColor,
                logo: logo,
                logoSizeRatio: logoSizeRatio,
                errorCorrectionLevel: errorCorrectionLevel
            )
        } catch {
            return nil
        }
    }
    
    private static func generateQRCodeInternalWithLogoThrowing(
        from data: Data,
        size: CGSize,
        color: UIColor,
        backgroundColor: UIColor,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        try generateQRCodeSharedWithLogoThrowing(
            from: data,
            size: size,
            color: color,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            filter: .none,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
}

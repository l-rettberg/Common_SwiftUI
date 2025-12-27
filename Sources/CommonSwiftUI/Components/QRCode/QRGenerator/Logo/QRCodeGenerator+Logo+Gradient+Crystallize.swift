//
//  QRCodeGenerator+Logo+Gradient+Crystallize.swift
//  CommonSwiftUI
//
//  Created by James Thang on 08/10/2024.
//

import UIKit

extension QRCodeGenerator {
    
    /// Generates a vintage-style QR code with a gradient fill from a string.
    ///
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - gradientColors: Array of colors to create the gradient.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code.
    ///   - logo: An optional logo to place at the center of the QR code.
    ///   - logoSizeRatio: The size of the logo relative to the QR code, as a ratio.
    ///   - errorCorrectionLevel: The error correction level of the QR code, affecting its resilience.
    /// - Returns: An optional `UIImage` of the QR code.
    ///
    /// This function uses gradient colors to enhance the visual appearance of QR codes while maintaining their scannability.
    public static func generateVintageQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) -> UIImage? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return generateVintageQRCode(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style gradient-filled QR code from a string and throws on failure.
    /// - Parameters:
    ///   - string: The string to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - gradientColors: Array of colors to create the gradient.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code.
    ///   - logo: An optional logo to place at the center of the QR code.
    ///   - logoSizeRatio: The size of the logo relative to the QR code, as a ratio.
    ///   - errorCorrectionLevel: The error correction level of the QR code, affecting its resilience.
    /// - Throws: `QRCodeGenerationError` if the QR code generation fails.
    /// - Returns: A `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from string: String,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) throws -> UIImage {
        guard let data = string.data(using: .utf8) else {
            throw QRCodeGenerationError.dataConversionFailed
        }
        return try generateVintageQRCode(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style gradient-filled QR code from a URL.
    /// - Parameters:
    ///   - url: The `URL` to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - gradientColors: Array of colors to create the gradient.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code.
    ///   - logo: An optional logo to place at the center of the QR code.
    ///   - logoSizeRatio: The size of the logo relative to the QR code, as a ratio.
    ///   - errorCorrectionLevel: The error correction level of the QR code, affecting its resilience.    /// - Returns: An optional `UIImage` containing the QR code.
    /// - Returns: An optional `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) -> UIImage? {
        return generateVintageQRCode(
            from: url.absoluteString,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style gradient-filled QR code from a URL and throws on failure.
    /// - Parameters:
    ///   - url: The `URL` to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - gradientColors: Array of colors to create the gradient.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code.
    ///   - logo: An optional logo to place at the center of the QR code.
    ///   - logoSizeRatio: The size of the logo relative to the QR code, as a ratio.
    ///   - errorCorrectionLevel: The error correction level of the QR code, affecting its resilience.    /// - Returns: An optional `UIImage` containing the QR code.
    /// - Throws: `QRCodeGenerationError` if the QR code generation fails.
    /// - Returns: A `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from url: URL,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high
    ) throws -> UIImage {
        return try generateVintageQRCode(
            from: url.absoluteString,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style gradient-filled QR code from binary data.
    /// - Parameters:
    ///   - data: Binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - gradientColors: Array of colors to create the gradient.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code.
    ///   - logo: An optional logo to place at the center of the QR code.
    ///   - logoSizeRatio: The size of the logo relative to the QR code, as a ratio.
    ///   - errorCorrectionLevel: The error correction level of the QR code, affecting its resilience.    /// - Returns: An optional `UIImage` containing the QR code.
    /// - Returns: An optional `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high // Use high error correction when embedding a logo
    ) -> UIImage? {
        return generateCrystallizeQRCodeInternalWithLogoGradient(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    /// Generates a vintage-style gradient-filled QR code from binary data and throws on failure.
    /// - Parameters:
    ///   - data: Binary data to encode in the QR code.
    ///   - size: The desired size of the output image.
    ///   - gradientColors: Array of colors to create the gradient.
    ///   - gradientDirection: The direction of the gradient.
    ///   - backgroundColor: The background color of the QR code.
    ///   - logo: An optional logo to place at the center of the QR code.
    ///   - logoSizeRatio: The size of the logo relative to the QR code, as a ratio.
    ///   - errorCorrectionLevel: The error correction level of the QR code, affecting its resilience.    /// - Returns: An optional `UIImage` containing the QR code.
    /// - Throws: `QRCodeGenerationError` if the QR code generation fails.
    /// - Returns: A `UIImage` containing the QR code.
    public static func generateVintageQRCode(
        from data: Data,
        size: CGSize = CGSize(width: 300, height: 300),
        gradientColors: [UIColor] = [UIColor.red, UIColor.blue],
        gradientDirection: GradientDirection = .topLeading,
        backgroundColor: UIColor = .clear,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat = 0.2,
        errorCorrectionLevel: ErrorCorrectionLevel = .high // Use high error correction when embedding a logo
    ) throws -> UIImage {
        return try generateCrystallizeQRCodeInternalWithLogoGradientThrowing(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
    //MARK: - Private Utility Methods

    private static func generateCrystallizeQRCodeInternalWithLogoGradient(
        from data: Data,
        size: CGSize,
        gradientColors: [UIColor],
        gradientDirection: GradientDirection,
        backgroundColor: UIColor,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) -> UIImage? {
        do {
            return try generateCrystallizeQRCodeInternalWithLogoGradientThrowing(
                from: data,
                size: size,
                gradientColors: gradientColors,
                gradientDirection: gradientDirection,
                backgroundColor: backgroundColor,
                logo: logo,
                logoSizeRatio: logoSizeRatio,
                errorCorrectionLevel: errorCorrectionLevel
            )
        } catch {
            return nil
        }
    }
    
    private static func generateCrystallizeQRCodeInternalWithLogoGradientThrowing(
        from data: Data,
        size: CGSize,
        gradientColors: [UIColor],
        gradientDirection: GradientDirection,
        backgroundColor: UIColor,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        try generateQRCodeSharedWithLogoGradientThrowing(
            from: data,
            size: size,
            gradientColors: gradientColors,
            gradientDirection: gradientDirection,
            backgroundColor: backgroundColor,
            logo: logo,
            logoSizeRatio: logoSizeRatio,
            filter: .crystallize,
            errorCorrectionLevel: errorCorrectionLevel
        )
    }
    
}

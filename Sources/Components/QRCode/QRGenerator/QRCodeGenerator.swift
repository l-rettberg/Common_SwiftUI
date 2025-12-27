//
//  QRCodeGenerator.swift
//  CommonSwiftUI
//
//  Created by James Thang on 23/08/2024.
//

import UIKit
import CoreImage.CIFilterBuiltins

/// A utility struct for generating QR codes from various types of inputs with options for customization.
///
/// The `QRCodeGenerator` provides static methods to create QR code images from different data sources such as strings, URLs, and binary data. It utilizes Core Image's built-in QR code generation capabilities to transform input data into visual QR code formats that can be scanned by QR code readers.
///
/// ## Features
///
/// - **Generate QR Codes from Strings, URLs, or Data**: Easily create QR codes from common data types.
/// - **Customization Options**: Specify size, colors, error correction levels, and embed logos.
/// - **Error Handling**: Methods throw `QRCodeGenerationError` to provide detailed error information.
///
/// ## Methods Overview
///
/// ### 1. Basic QR Code Generation (Optional UIImage)
///
/// These methods return an optional `UIImage` and do not throw errors.
///
/// - `generateQRCode(from string: String) -> UIImage?`
/// - `generateQRCode(from url: URL) -> UIImage?`
/// - `generateQRCode(from data: Data) -> UIImage?`
///
/// ### 2. Basic QR Code Generation with Error Handling
///
/// These methods throw `QRCodeGenerationError` and return a non-optional `UIImage`.
///
/// - `generateQRCode(from string: String) throws -> UIImage`
/// - `generateQRCode(from url: URL) throws -> UIImage`
/// - `generateQRCode(from data: Data) throws -> UIImage`
///
/// ### 3. Customized QR Code Generation
///
/// Methods that allow customization of size, colors, and error correction level.
///
/// - `generateQRCode(from string: String, size: CGSize, color: UIColor, backgroundColor: UIColor, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
/// - `generateQRCode(from url: URL, size: CGSize, color: UIColor, backgroundColor: UIColor, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
/// - `generateQRCode(from data: Data, size: CGSize, color: UIColor, backgroundColor: UIColor, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// ### 4. Customized QR Code Generation with Logo Embedding
///
/// Methods that allow embedding a logo or image at the center of the QR code.
///
/// - `generateQRCode(from data: Data, size: CGSize, color: UIColor, backgroundColor: UIColor, logo: UIImage?, logoSizeRatio: CGFloat, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
/// - `generateQRCode(from string: String, size: CGSize, color: UIColor, backgroundColor: UIColor, logo: UIImage?, logoSizeRatio: CGFloat, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
/// - `generateQRCode(from url: URL, size: CGSize, color: UIColor, backgroundColor: UIColor, logo: UIImage?, logoSizeRatio: CGFloat, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// ## Usage Examples
///
/// ### Basic QR Code Generation (Optional UIImage)
///
/// ```swift
/// if let qrCodeImage = QRCodeGenerator.generateQRCode(from: "Hello, World!") {
///     imageView.image = qrCodeImage
/// } else {
///     print("Failed to generate QR code.")
/// }
/// ```
///
/// ### Basic QR Code Generation with Error Handling
///
/// ```swift
/// do {
///     let qrCodeImage = try QRCodeGenerator.generateQRCode(from: "Hello, World!")
///     imageView.image = qrCodeImage
/// } catch {
///     print("Error generating QR code: \(error.localizedDescription)")
/// }
/// ```
///
/// ### Customized QR Code Generation
///
/// ```swift
/// do {
///     let qrCodeImage = try QRCodeGenerator.generateQRCode(
///         from: "Customized QR Code",
///         size: CGSize(width: 300, height: 300),
///         color: .blue,
///         backgroundColor: .yellow,
///         errorCorrectionLevel: .high
///     )
///     imageView.image = qrCodeImage
/// } catch {
///     print("Error generating QR code: \(error.localizedDescription)")
/// }
/// ```
///
/// ### QR Code Generation with Logo Embedding
///
/// ```swift
/// do {
///     let logoImage = UIImage(named: "logo.png")
///     let qrCodeImage = try QRCodeGenerator.generateQRCode(
///         from: "QR Code with Logo",
///         size: CGSize(width: 300, height: 300),
///         color: .black,
///         backgroundColor: .white,
///         logo: logoImage,
///         logoSizeRatio: 0.2,
///         errorCorrectionLevel: .high
///     )
///     imageView.image = qrCodeImage
/// } catch {
///     print("Error generating QR code: \(error.localizedDescription)")
/// }
/// ```
///
/// ## ErrorCorrectionLevel Enum
///
/// ```swift
/// public enum ErrorCorrectionLevel: String {
///     case low = "L"       // Low error correction level (7% recovery).
///     case medium = "M"    // Medium error correction level (15% recovery).
///     case quartile = "Q"  // Quartile error correction level (25% recovery).
///     case high = "H"      // High error correction level (30% recovery).
/// }
/// ```
///
/// ## Notes
///
/// - **Error Correction Level**: Higher levels increase the QR code's resilience to errors but also make it denser. Use higher levels when embedding logos.
/// - **Logo Embedding**: When embedding a logo, ensure it doesn't cover more than 30% of the QR code area to maintain scannability.
/// - **Color Contrast**: Ensure sufficient contrast between `color` and `backgroundColor` for readability.
///
/// ## Thread Safety
///
/// QR code generation runs on the calling thread. If used in a UI context, consider performing the operation on a background thread to avoid blocking the main thread.
///
/// ## See Also
///
/// - `CIFilter`
/// - `CIImage`
/// - `UIImage`
///
/// ## Implementation Details
///
/// The struct is divided into extensions for better organization:
///
/// - **Basic Generation Methods**: Provide simple QR code generation from `String`, `URL`, or `Data`.
/// - **Error-Throwing Methods**: Similar to basic methods but throw errors instead of returning optional images.
/// - **Customized Generation Methods**: Allow specifying size, colors, and error correction levels.
/// - **Logo Embedding Methods**: Extend customized methods to embed logos.
///
/// ---
///
/// Below is the detailed documentation for each method:
///
/// ### `generateQRCode(from string: String) -> UIImage?`
///
/// Generates a QR code image from a string. Returns an optional `UIImage`, or `nil` if generation fails.
///
/// - **Parameter**: `string` - The string to encode in the QR code.
///
/// ### `generateQRCode(from url: URL) -> UIImage?`
///
/// Generates a QR code image from a URL. Returns an optional `UIImage`, or `nil` if generation fails.
///
/// - **Parameter**: `url` - The URL to encode in the QR code.
///
/// ### `generateQRCode(from data: Data) -> UIImage?`
///
/// Generates a QR code image from binary data. Returns an optional `UIImage`, or `nil` if generation fails.
///
/// - **Parameter**: `data` - The binary data to encode in the QR code.
///
/// ### `generateQRCode(from string: String) throws -> UIImage`
///
/// Generates a QR code image from a string. Throws `QRCodeGenerationError` if generation fails.
///
/// - **Parameter**: `string` - The string to encode in the QR code.
///
/// ### `generateQRCode(from url: URL) throws -> UIImage`
///
/// Generates a QR code image from a URL. Throws `QRCodeGenerationError` if generation fails.
///
/// - **Parameter**: `url` - The URL to encode in the QR code.
///
/// ### `generateQRCode(from data: Data) throws -> UIImage`
///
/// Generates a QR code image from binary data. Throws `QRCodeGenerationError` if generation fails.
///
/// - **Parameter**: `data` - The binary data to encode in the QR code.
///
/// ### `generateQRCode(from string: String, size: CGSize, color: UIColor, backgroundColor: UIColor, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// Generates a customized QR code image from a string.
///
/// - **Parameters**:
///   - `string`: The string to encode.
///   - `size`: Desired image size.
///   - `color`: Color of the QR code squares.
///   - `backgroundColor`: Background color of the image.
///   - `errorCorrectionLevel`: Error correction level.
///
/// ### `generateQRCode(from url: URL, size: CGSize, color: UIColor, backgroundColor: UIColor, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// Generates a customized QR code image from a URL.
///
/// - **Parameters**:
///   - `url`: The URL to encode.
///   - `size`: Desired image size.
///   - `color`: Color of the QR code squares.
///   - `backgroundColor`: Background color of the image.
///   - `errorCorrectionLevel`: Error correction level.
///
/// ### `generateQRCode(from data: Data, size: CGSize, color: UIColor, backgroundColor: UIColor, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// Generates a customized QR code image from binary data.
///
/// - **Parameters**:
///   - `data`: The data to encode.
///   - `size`: Desired image size.
///   - `color`: Color of the QR code squares.
///   - `backgroundColor`: Background color of the image.
///   - `errorCorrectionLevel`: Error correction level.
///
/// ### `generateQRCode(from data: Data, size: CGSize, color: UIColor, backgroundColor: UIColor, logo: UIImage?, logoSizeRatio: CGFloat, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// Generates a QR code image from data with a logo embedded.
///
/// - **Parameters**:
///   - `data`: The data to encode.
///   - `size`: Desired image size.
///   - `color`: Color of the QR code squares.
///   - `backgroundColor`: Background color of the image.
///   - `logo`: Image to embed at the center.
///   - `logoSizeRatio`: Size ratio of the logo relative to the QR code size.
///   - `errorCorrectionLevel`: Error correction level.
///
/// ### `generateQRCode(from string: String, size: CGSize, color: UIColor, backgroundColor: UIColor, logo: UIImage?, logoSizeRatio: CGFloat, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// Generates a QR code image from a string with a logo embedded.
///
/// - **Parameters**:
///   - `string`: The string to encode.
///   - `size`: Desired image size.
///   - `color`: Color of the QR code squares.
///   - `backgroundColor`: Background color of the image.
///   - `logo`: Image to embed at the center.
///   - `logoSizeRatio`: Size ratio of the logo relative to the QR code size.
///   - `errorCorrectionLevel`: Error correction level.
///
/// ### `generateQRCode(from url: URL, size: CGSize, color: UIColor, backgroundColor: UIColor, logo: UIImage?, logoSizeRatio: CGFloat, errorCorrectionLevel: ErrorCorrectionLevel) throws -> UIImage`
///
/// Generates a QR code image from a URL with a logo embedded.
///
/// - **Parameters**:
///   - `url`: The URL to encode.
///   - `size`: Desired image size.
///   - `color`: Color of the QR code squares.
///   - `backgroundColor`: Background color of the image.
///   - `logo`: Image to embed at the center.
///   - `logoSizeRatio`: Size ratio of the logo relative to the QR code size.
///   - `errorCorrectionLevel`: Error correction level.
public struct QRCodeGenerator {
    
    /// Generates a QR code image from a given string.
    ///
    /// Converts the string to a UTF-8 encoded data format and then processes this data to create a QR code image.
    /// - Parameter string: The string to encode in the QR code.
    /// - Returns: An optional `UIImage` containing the generated QR code, or `nil` if generation fails.
    public static func generateQRCode(from string: String) -> UIImage? {
        return generateQRCode(from: Data(string.utf8))
    }
    
    /// Generates a QR code image from a given string.
    ///
    /// Converts the string to a UTF-8 encoded data format and then processes this data to create a QR code image.
    /// - Parameter string: The string to encode in the QR code.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code.
    public static func generateQRCode(from string: String) throws -> UIImage {
        guard let data = string.data(using: .utf8) else {
            throw QRCodeGenerationError.dataConversionFailed
        }
        
        return try generateQRCode(from: data)
    }
    
    /// Generates a QR code image from a given URL.
    ///
    /// Converts the URL to a string representation and then generates a QR code image from this string.
    /// - Parameter url: The URL to encode in the QR code.
    /// - Returns: An optional `UIImage` containing the generated QR code, or `nil` if generation fails.
    public static func generateQRCode(from url: URL) -> UIImage? {
        return generateQRCode(from: url.absoluteString)
    }
    
    /// Generates a QR code image from a given URL.
    ///
    /// Converts the URL to a string representation and then generates a QR code image from this string.
    /// - Parameter url: The URL to encode in the QR code.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code.
    public static func generateQRCode(from url: URL) throws -> UIImage {
        return try generateQRCode(from: url.absoluteString)
    }
    
    /// Generates a QR code image from binary data.
    ///
    /// Directly uses the provided binary data to generate a QR code image using a Core Image filter.
    /// - Parameter data: The binary data to encode in the QR code.
    /// - Returns: An optional `UIImage` containing the generated QR code, or `nil` if generation fails.
    public static func generateQRCode(from data: Data) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }

    /// Generates a QR code image from binary data.
    ///
    /// Directly uses the provided binary data to generate a QR code image using a Core Image filter.
    /// - Parameter data: The binary data to encode in the QR code.
    /// - Throws: `QRCodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated QR code.
    public static func generateQRCode(from data: Data) throws -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        guard let outputImage = filter.outputImage else {
            throw QRCodeGenerationError.outputImageCreationFailed
        }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            throw QRCodeGenerationError.cgImageCreationFailed
        }
        
        return UIImage(cgImage: cgImage)
    }
    
}


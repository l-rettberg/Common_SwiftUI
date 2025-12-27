//
//  BarcodeGenerator.swift
//  CommonSwiftUI
//
//  Created by James Thang on 20/09/2024.
//

import UIKit
import CoreImage

/// A utility struct for generating barcode images from various data types.
///
/// The `BarcodeGenerator` struct provides functionalities to create barcode images using Core Image filters.
/// It supports multiple barcode formats defined in the `BarcodeFormat` enum and offers throwing methods for barcode generation.
/// This ensures that any errors encountered during barcode generation are explicitly handled, promoting safer and more predictable code.
///
/// ## Supported Barcode Formats
///
/// The following barcode formats are supported by `BarcodeGenerator`:
///
/// - **Code 128**: A high-density linear barcode suitable for encoding a wide range of characters.
/// - **PDF417**: A stacked linear barcode format used in various applications, including transport and identification.
/// - **Aztec**: A compact 2D barcode format with robust error correction, often used in mobile ticketing.
/// - **QR Code**: A widely recognized 2D barcode capable of encoding URLs, text, and other data.
///
/// ## Functionality Overview
///
/// `BarcodeGenerator` provides the following primary functionalities:
///
/// These methods attempt to generate a barcode image and throw specific errors if generation fails. Or we also have an optional return variables
///
/// - `generateCode(from:data:format:size:color:backgroundColor:)`
/// - `generateCode(from:string:format:size:color:backgroundColor:)`
/// - `generateCode(from:url:format:size:color:backgroundColor:)`
/// - `generateCode(from:number:format:size:color:backgroundColor:)`
///
/// ## Usage Example
///
/// ```swift
/// do {
///     let barcodeImage = try BarcodeGenerator.generateCode(
///         from: "https://example.com",
///         format: .qrCode,
///         size: CGSize(width: 300, height: 300),
///         color: .black,
///         backgroundColor: .white
///     )
///     // Use barcodeImage as needed
/// } catch {
///     print("Barcode generation failed with error: \(error.localizedDescription)")
/// }
/// ```
public struct BarcodeGenerator {
    
    // Shared CIContext to improve performance
    private static let context = CIContext()
    
    /// Generates a barcode image from given data.
    ///
    /// - Parameters:
    ///   - data: The binary data to encode in the barcode.
    ///   - format: The format of the barcode to generate (e.g., Code 128, PDF417, QR Code).
    ///   - size: The desired size of the barcode image (no default, must be provided).
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Returns: A `UIImage` containing the generated barcode, or `nil` if generation fails.
    public static func generateCode(
        from data: Data,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) -> UIImage? {
        guard let filter = CIFilter(name: format.filterName) else { return nil }
        
        filter.setValue(data, forKey: "inputMessage")
        
        // Optional handling for additional parameters, e.g., QR Code correction level
        if format == .qrCode {
            filter.setValue("M", forKey: "inputCorrectionLevel")
        }
        
        guard let ciImage = filter.outputImage else { return nil }
        
        // Apply color filter
        let coloredFilter = CIFilter(name: "CIFalseColor",
                                     parameters: [
                                        "inputImage": ciImage,
                                        "inputColor0": CIColor(color: color),
                                        "inputColor1": CIColor(color: backgroundColor)
                                     ])
        guard let coloredImage = coloredFilter?.outputImage else { return nil }
        
        // Scale the image
        let transform = CGAffineTransform(scaleX: size.width / coloredImage.extent.size.width,
                                          y: size.height / coloredImage.extent.size.height)
        let scaledImage = coloredImage.transformed(by: transform)
        
        // Create CGImage and return UIImage
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// Convenience method to generate a barcode image from a given string.
    ///
    /// - Parameters:
    ///   - string: The string to encode in the barcode.
    ///   - format: The format of the barcode to generate (e.g., Code 128, PDF417, QR Code).
    ///   - size: The desired size of the barcode image (no default, must be provided).
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Returns: A `UIImage` containing the generated barcode, or `nil` if generation fails.
    public static func generateCode(
        from string: String,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) -> UIImage? {
        guard let data = string.data(using: .utf8) else { return nil }
        return generateCode(from: data, format: format, size: size, color: color, backgroundColor: backgroundColor)
    }
    
    /// Convenience method to generate a barcode image from a given URL.
    ///
    /// - Parameters:
    ///   - url: The URL to encode in the barcode.
    ///   - format: The format of the barcode to generate (e.g., QR Code, Aztec).
    ///   - size: The desired size of the barcode image (no default, must be provided).
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Returns: A `UIImage` containing the generated barcode, or `nil` if generation fails.
    public static func generateCode(
        from url: URL,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) -> UIImage? {
        let urlString = url.absoluteString
        return generateCode(from: urlString, format: format, size: size, color: color, backgroundColor: backgroundColor)
    }
    
    /// Convenience method to generate a barcode image from a given integer.
    ///
    /// - Parameters:
    ///   - number: The integer to encode in the barcode.
    ///   - format: The format of the barcode to generate (e.g., Code 128, UPC-A, EAN-13).
    ///   - size: The desired size of the barcode image (no default, must be provided).
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Returns: A `UIImage` containing the generated barcode, or `nil` if generation fails.
    public static func generateCode(
        from number: Int,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) -> UIImage? {
        let numberString = String(number)
        return generateCode(from: numberString, format: format, size: size, color: color, backgroundColor: backgroundColor)
    }
    
}

extension BarcodeGenerator {
    
    /// Throws an error if barcode generation fails.
    ///
    /// - Parameters:
    ///   - data: The binary data to encode in the barcode.
    ///   - format: The format of the barcode to generate.
    ///   - size: The desired size of the barcode image.
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Throws: `BarcodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated barcode.
    public static func generateCode(
        from data: Data,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) throws -> UIImage {
        guard let filter = CIFilter(name: format.filterName) else {
            throw BarcodeGenerationError.invalidFilter
        }
        
        filter.setValue(data, forKey: "inputMessage")
        
        // Handle additional parameters for specific formats
        if format == .qrCode {
            filter.setValue("M", forKey: "inputCorrectionLevel")
        }
        
        guard let ciImage = filter.outputImage else {
            throw BarcodeGenerationError.outputImageGenerationFailed
        }
        
        // Apply color filter
        guard let coloredFilter = CIFilter(name: "CIFalseColor",
                                           parameters: [
                                            "inputImage": ciImage,
                                            "inputColor0": CIColor(color: color),
                                            "inputColor1": CIColor(color: backgroundColor)
                                           ]),
              let coloredImage = coloredFilter.outputImage else {
            throw BarcodeGenerationError.outputImageGenerationFailed
        }
        
        // Scale the image
        let scaleX = size.width / coloredImage.extent.size.width
        let scaleY = size.height / coloredImage.extent.size.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaledImage = coloredImage.transformed(by: transform)
        
        // Create CGImage and return UIImage
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            throw BarcodeGenerationError.cgImageCreationFailed
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// Convenience method that throws an error if barcode generation from a string fails.
    ///
    /// - Parameters:
    ///   - string: The string to encode in the barcode.
    ///   - format: The format of the barcode to generate.
    ///   - size: The desired size of the barcode image.
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Throws: `BarcodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated barcode.
    public static func generateCode(
        from string: String,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) throws -> UIImage {
        guard let data = string.data(using: .utf8) else {
            throw BarcodeGenerationError.invalidInputData
        }
        return try generateCode(from: data, format: format, size: size, color: color, backgroundColor: backgroundColor)
    }
    
    /// Convenience method that throws an error if barcode generation from a URL fails.
    ///
    /// - Parameters:
    ///   - url: The URL to encode in the barcode.
    ///   - format: The format of the barcode to generate.
    ///   - size: The desired size of the barcode image.
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Throws: `BarcodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated barcode.
    public static func generateCode(
        from url: URL,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) throws -> UIImage {
        let urlString = url.absoluteString
        return try generateCode(from: urlString, format: format, size: size, color: color, backgroundColor: backgroundColor)
    }
    
    /// Convenience method that throws an error if barcode generation from an integer fails.
    ///
    /// - Parameters:
    ///   - number: The integer to encode in the barcode.
    ///   - format: The format of the barcode to generate.
    ///   - size: The desired size of the barcode image.
    ///   - color: The color of the barcode. Defaults to label color.
    ///   - backgroundColor: The background color of the barcode image. Defaults to clear color.
    /// - Throws: `BarcodeGenerationError` if generation fails.
    /// - Returns: A `UIImage` containing the generated barcode.
    public static func generateCode(
        from number: Int,
        format: BarcodeFormat,
        size: CGSize,
        color: UIColor = .label,
        backgroundColor: UIColor = .clear
    ) throws -> UIImage {
        let numberString = String(number)
        return try generateCode(from: numberString, format: format, size: size, color: color, backgroundColor: backgroundColor)
    }
    
}

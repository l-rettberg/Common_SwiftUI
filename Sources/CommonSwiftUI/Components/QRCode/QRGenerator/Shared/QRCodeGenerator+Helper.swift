//
//  QRCodeGenerator+Helper.swift
//  CommonSwiftUI
//
//  Created by James Thang on 07/10/2024.
//

import UIKit
import CoreImage.CIFilterBuiltins

extension QRCodeGenerator {
    
    static func generateQRCodeImage(from data: Data, errorCorrectionLevel: ErrorCorrectionLevel) throws -> CIImage {
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(errorCorrectionLevel.rawValue, forKey: "inputCorrectionLevel")
        
        guard let outputImage = filter.outputImage else {
            throw QRCodeGenerationError.outputImageCreationFailed
        }
        
        return outputImage
    }
    
    static func createCGImage(from ciImage: CIImage) throws -> CGImage {
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            throw QRCodeGenerationError.cgImageCreationFailed
        }
        
        return cgImage
    }
    
    static func blendWithMask(gradientImage: CIImage, maskImage: CIImage, backgroundColor: UIColor, extent: CGRect) throws -> CIImage {
        let blendFilter = CIFilter.blendWithMask()
        blendFilter.setValue(gradientImage, forKey: kCIInputImageKey) // Foreground (gradient)
        blendFilter.setValue(CIImage(color: CIColor(color: backgroundColor)).cropped(to: extent), forKey: kCIInputBackgroundImageKey)   // Background (specified color)
        blendFilter.setValue(maskImage, forKey: kCIInputMaskImageKey)   // Mask (QR code)
        
        guard let blendedImage = blendFilter.outputImage else {
            throw QRCodeGenerationError.blendFilterCreationFailed
        }
        
        return blendedImage
    }
    
    static func scaleQRCodeImage(_ qrImage: CIImage, to size: CGSize) throws -> CIImage {
        let qrCodeSize = qrImage.extent.size
        
        if size.width < qrCodeSize.width || size.height < qrCodeSize.height {
            throw QRCodeGenerationError.sizeTooSmall(minimumSize: qrCodeSize)
        }
        
        let widthRatio = size.width / qrCodeSize.width
        let heightRatio = size.height / qrCodeSize.height
        let scale = min(widthRatio, heightRatio)
        let scaleFactor = max(floor(scale), 1.0)
        
        let transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        return qrImage.transformed(by: transform)
    }
    
    static func createGradientImage(size: CGSize, gradientColors: [UIColor], gradientDirection: GradientDirection, backgroundColor: UIColor) throws -> CIImage {
        UIGraphicsBeginImageContext(size)
        guard let graphicsContext = UIGraphicsGetCurrentContext() else {
            throw QRCodeGenerationError.graphicsContextCreationFailed
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map { $0.cgColor } as CFArray
        let gradientLocations: [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: gradientLocations) else {
            throw QRCodeGenerationError.gradientCreationFailed
        }
        
        // Get the gradient points from the direction
        let gradientPoints = gradientDirection.points(for: size)
        
        // Draw the gradient
        graphicsContext.drawLinearGradient(
            gradient,
            start: gradientPoints.startPoint,
            end: gradientPoints.endPoint,
            options: []
        )
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            throw QRCodeGenerationError.outputImageCreationFailed
        }
        
        UIGraphicsEndImageContext()
        
        guard let gradientCIImage = CIImage(image: gradientImage) else {
            throw QRCodeGenerationError.ciImageCreationFailed
        }
        
        return gradientCIImage
    }
    
    //MARK: - Bitmap
    
    static func createBitmapContext(size: CGSize) throws -> CGContext {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            throw QRCodeGenerationError.bitmapContextCreationFailed
        }
        
        return context
    }
    
    static func clearBitmapContext(_ context: CGContext, size: CGSize) {
        context.clear(CGRect(origin: .zero, size: size))
    }
    
    static func drawQRCodeInBitmapContext(_ context: CGContext, cgImage: CGImage, size: CGSize, scaledSize: CGSize) {
        let originX = (size.width - scaledSize.width) / 2.0
        let originY = (size.height - scaledSize.height) / 2.0
        let drawRect = CGRect(origin: CGPoint(x: originX, y: originY), size: scaledSize)
        
        context.interpolationQuality = .none
        context.setBlendMode(.copy)
        context.draw(cgImage, in: drawRect)
    }
    
    static func makeFinalCGImageFromBitmap(from context: CGContext) throws -> CGImage {
        guard let cgImage = context.makeImage() else {
            throw QRCodeGenerationError.finalImageCreationFailed
        }
        
        return cgImage
    }
    
    //MARK: - Logo drawing
    
    static func drawLogoInBitmapContext(
        _ context: CGContext,
        logo: UIImage,
        size: CGSize,
        qrSize: CGSize,
        logoSizeRatio: CGFloat
    ) {
        // Calculate the maximum size for the logo
        let maxLogoWidth = qrSize.width * logoSizeRatio
        let maxLogoHeight = qrSize.height * logoSizeRatio
        
        // Get the size of the logo image
        let logoSize = logo.size
        
        // Calculate the scaling factor to maintain aspect ratio
        let widthScale = maxLogoWidth / logoSize.width
        let heightScale = maxLogoHeight / logoSize.height
        let scaleFactor = min(widthScale, heightScale)
        
        // Calculate the new size of the logo
        let scaledLogoSize = CGSize(width: logoSize.width * scaleFactor, height: logoSize.height * scaleFactor)
        
        // Calculate the position to center the logo within the QR code
        let qrOriginX = (size.width - qrSize.width) / 2.0
        let qrOriginY = (size.height - qrSize.height) / 2.0
        let logoOriginX = qrOriginX + (qrSize.width - scaledLogoSize.width) / 2.0
        let logoOriginY = qrOriginY + (qrSize.height - scaledLogoSize.height) / 2.0
        let logoRect = CGRect(origin: CGPoint(x: logoOriginX, y: logoOriginY), size: scaledLogoSize)
        
        // Draw the logo
        context.setBlendMode(.normal)
        context.interpolationQuality = .high
        if let logoCGImage = logo.cgImage {
            context.draw(logoCGImage, in: logoRect)
        } else {
            // If the logo has no CGImage (e.g., it's a CIImage), draw it using UIKit
            UIGraphicsPushContext(context)
            logo.draw(in: logoRect)
            UIGraphicsPopContext()
        }
    }
    
    //MARK: - CIFilters
    
    static func applyFalseColorFilter(to qrImage: CIImage, qrColor: UIColor, backgroundColor: UIColor) throws -> CIImage {
        let colorFilter = CIFilter.falseColor()
        colorFilter.setValue(qrImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: qrColor), forKey: "inputColor0") // QR code squares
        colorFilter.setValue(CIColor(color: backgroundColor), forKey: "inputColor1") // Background
        
        guard let coloredImage = colorFilter.outputImage else {
            throw QRCodeGenerationError.outputImageCreationFailed
        }
        
        return coloredImage
    }
    
    static func applyInvertColorsFilter(to image: CIImage) throws -> CIImage {
        let invertFilter = CIFilter.colorInvert()
        invertFilter.setValue(image, forKey: kCIInputImageKey)
        
        guard let invertedImage = invertFilter.outputImage else {
            throw QRCodeGenerationError.outputImageCreationFailed
        }
        
        return invertedImage
    }
    
    static func applyAlphaMaskFilter(to image: CIImage) throws -> CIImage {
        let maskToAlphaFilter = CIFilter.maskToAlpha()
        maskToAlphaFilter.setValue(image, forKey: kCIInputImageKey)
        
        guard let maskImage = maskToAlphaFilter.outputImage else {
            throw QRCodeGenerationError.outputImageCreationFailed
        }
        
        return maskImage
    }
    
    static func applyCrystallizeFilter(to image: CIImage) throws -> CIImage {
        let crystallizeFilter = CIFilter.crystallize()
        crystallizeFilter.setValue(image, forKey: kCIInputImageKey)
        crystallizeFilter.setValue(2.0, forKey: kCIInputRadiusKey) // Adjust radius as needed
        crystallizeFilter.setValue(CIVector(x: image.extent.midX, y: image.extent.midY), forKey: kCIInputCenterKey)
        
        guard let crystallizedImage = crystallizeFilter.outputImage else {
            throw QRCodeGenerationError.outputImageCreationFailed
        }

        return crystallizedImage
    }
    
    //MARK: - Shared
    
    static func generateQRCodeColorSharedThrowing(
        from data: Data,
        size: CGSize,
        color: UIColor,
        backgroundColor: UIColor,
        filter: QRAdditionalFilter,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        // Step 1: Generate the QR code
        let qrImage = try generateQRCodeImage(from: data, errorCorrectionLevel: errorCorrectionLevel)
        
        // Step 2: Apply false color filter to set QR code colors
        let coloredImage = try applyFalseColorFilter(to: qrImage, qrColor: color, backgroundColor: backgroundColor)
        
        // Step 3: Scale the QR code image
        let scaledImage = try scaleQRCodeImage(coloredImage, to: size)
        
        // Step 4: Create CGImage from the scaled CIImage
        let cgImage = try applyAdditionalFilter(to: scaledImage, filter: filter)
                        
        // Step 5: Create a bitmap context with the desired size and RGBA color space
        let bitmapContext = try createBitmapContext(size: size)
        
        // Step 6: Clear the bitmap context (transparent background)
        clearBitmapContext(bitmapContext, size: size)

        // Step 7: Draw the QR code image into the bitmap context
        let scaledSize = CGSize(width: scaledImage.extent.width, height: scaledImage.extent.height)
        drawQRCodeInBitmapContext(bitmapContext, cgImage: cgImage, size: size, scaledSize: scaledSize)
        
        // Step 8: Create UIImage from the bitmap context
        let finalCGImage = try makeFinalCGImageFromBitmap(from: bitmapContext)
        
        return UIImage(cgImage: finalCGImage)
    }
    
    static func generateGradientQRCodeSharedThrowing(
        from data: Data,
        size: CGSize,
        gradientColors: [UIColor],
        gradientDirection: GradientDirection,
        backgroundColor: UIColor,
        filter: QRAdditionalFilter,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        // Step 1: Generate the QR code
        let qrImage = try generateQRCodeImage(from: data, errorCorrectionLevel: errorCorrectionLevel)
        
        // Step 2: Scale the QR code to improve resolution
        let scaledQRImage = try scaleQRCodeImage(qrImage, to: size)
        
        // Step 3: Invert the QR code colors
        let invertedQRImage = try applyInvertColorsFilter(to: scaledQRImage)
        
        // Step 4: Convert the inverted QR code to an alpha mask
        let maskImage = try applyAlphaMaskFilter(to: invertedQRImage)
        
        // Step 5: Create the gradient image
        let size = CGSize(width: scaledQRImage.extent.width, height: scaledQRImage.extent.height)
        let gradientCIImage = try createGradientImage(size: size, gradientColors: gradientColors, gradientDirection: gradientDirection, backgroundColor: backgroundColor)
        
        // Step 6: Use the mask to apply the gradient to the QR code
        let blendedImage = try blendWithMask(gradientImage: gradientCIImage, maskImage: maskImage, backgroundColor: backgroundColor, extent: scaledQRImage.extent)
        
        // Step 7: Create the final UIImage
        let cgImage = try applyAdditionalFilter(to: blendedImage, filter: filter)
                
        return UIImage(cgImage: cgImage)
    }
    
    static func generateQRCodeSharedWithLogoThrowing(
        from data: Data,
        size: CGSize,
        color: UIColor,
        backgroundColor: UIColor,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat,
        filter: QRAdditionalFilter,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        // Step 1: Generate the QR code
        let qrImage = try generateQRCodeImage(from: data, errorCorrectionLevel: errorCorrectionLevel)
        
        // Step 2: Apply false color filter to set QR code colors
        let coloredImage = try applyFalseColorFilter(to: qrImage, qrColor: color, backgroundColor: backgroundColor)
        
        // Step 3: Scale the QR code image
        let scaledImage = try scaleQRCodeImage(coloredImage, to: size)
        
        // Step 4: Create CGImage from the scaled CIImage
        let cgImage = try applyAdditionalFilter(to: scaledImage, filter: filter)
                
        // Step 5: Create a bitmap context with the desired size and RGBA color space
        let bitmapContext = try createBitmapContext(size: size)
        
        // Step 6: Clear the bitmap context (transparent background)
        clearBitmapContext(bitmapContext, size: size)

        // Step 7: Draw the QR code image into the bitmap context
        let scaledQRCodeSize = CGSize(width: scaledImage.extent.width, height: scaledImage.extent.height)
        drawQRCodeInBitmapContext(bitmapContext, cgImage: cgImage, size: size, scaledSize: scaledQRCodeSize)
        
        // Step 8: Embed the logo if provided
        if let logo {
            drawLogoInBitmapContext(bitmapContext, logo: logo, size: size, qrSize: scaledQRCodeSize, logoSizeRatio: logoSizeRatio)
        }
        
        // Step 9: Create UIImage from the bitmap context
        let finalCGImage = try makeFinalCGImageFromBitmap(from: bitmapContext)
        
        return UIImage(cgImage: finalCGImage)
    }
    
    static func generateQRCodeSharedWithLogoGradientThrowing(
        from data: Data,
        size: CGSize,
        gradientColors: [UIColor],
        gradientDirection: GradientDirection,
        backgroundColor: UIColor,
        logo: UIImage? = nil,
        logoSizeRatio: CGFloat,
        filter: QRAdditionalFilter,
        errorCorrectionLevel: ErrorCorrectionLevel
    ) throws -> UIImage {
        // Step 1: Generate the QR code
        let qrImage = try generateQRCodeImage(from: data, errorCorrectionLevel: errorCorrectionLevel)
        
        // Step 2: Scale the QR code to improve resolution
        let scaledQRImage = try scaleQRCodeImage(qrImage, to: size)
        
        // Step 3: Invert the QR code colors
        let invertedQRImage = try applyInvertColorsFilter(to: scaledQRImage)
        
        // Step 4: Convert the inverted QR code to an alpha mask
        let maskImage = try applyAlphaMaskFilter(to: invertedQRImage)
        
        // Step 5: Create the gradient image
        let size = CGSize(width: scaledQRImage.extent.width, height: scaledQRImage.extent.height)
        let gradientCIImage = try createGradientImage(size: size, gradientColors: gradientColors, gradientDirection: gradientDirection, backgroundColor: backgroundColor)
        
        // Step 6: Use the mask to apply the gradient to the QR code
        let blendedImage = try blendWithMask(gradientImage: gradientCIImage, maskImage: maskImage, backgroundColor: backgroundColor, extent: scaledQRImage.extent)
        
        // Step 7: Create the final UIImage
        let cgImage = try applyAdditionalFilter(to: blendedImage, filter: filter)
        
        // Step 8: Create a bitmap context with the desired size and RGBA color space
        let bitmapContext = try createBitmapContext(size: size)
        
        // Step 9: Clear the bitmap context (transparent background)
        clearBitmapContext(bitmapContext, size: size)

        // Step 10: Draw the QR code image into the bitmap context
        let scaledQRCodeSize = CGSize(width: scaledQRImage.extent.width, height: scaledQRImage.extent.height)
        drawQRCodeInBitmapContext(bitmapContext, cgImage: cgImage, size: size, scaledSize: scaledQRCodeSize)
        
        // Step 11: Embed the logo if provided
        if let logo {
            drawLogoInBitmapContext(bitmapContext, logo: logo, size: size, qrSize: scaledQRCodeSize, logoSizeRatio: logoSizeRatio)
        }
        
        // Step 12: Create UIImage from the bitmap context
        let finalCGImage = try makeFinalCGImageFromBitmap(from: bitmapContext)
        
        return UIImage(cgImage: finalCGImage)
    }
    
    private static func applyAdditionalFilter(to image: CIImage, filter: QRAdditionalFilter) throws -> CGImage {
        switch filter {
        case .crystallize:
            // Step 1: Apply the Crystallize filter
            let crystallizedImage = try applyCrystallizeFilter(to: image)
            // Step 2: Crop the Crystallize image to match the original size
            let croppedImage = crystallizedImage.cropped(to: image.extent)
            // Step 3: Create CGImage from the cropped CIImage
            return try createCGImage(from: croppedImage)
        case .none:
            return try createCGImage(from: image)
        }
    }
    
}

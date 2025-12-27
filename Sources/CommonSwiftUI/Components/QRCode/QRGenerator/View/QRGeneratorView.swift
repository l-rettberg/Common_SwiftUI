//
//  QRGeneratorView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 23/08/2024.
//

import SwiftUI

/// A SwiftUI view component that generates and displays a QR code from various input types.
///
/// QRGeneratorView creates a QR code image based on the provided input, which can be a` String`, `URL`, or `Data`. It displays the generated QR code image or an error message if the QR code generation fails.
///
/// - Parameters:
/// - input: The data used to generate the QR code, specified by the `QRCodeInputType` enumeration.
///
/// ## Example:
/// ```swift
/// QRGeneratorView(input: .string("https://github.com/Enryun/Common_SwiftUI"))
/// ```
/// 
/// This component simplifies the process of QR code generation and display within SwiftUI views, handling different input types seamlessly.
/// 
public struct QRGeneratorView: View {
    
    var input: QRCodeInputType
    @State private var qrImage: UIImage?
    
    public init(input: QRCodeInputType) {
        self.input = input
    }
    
    public var body: some View {
        ZStack {
            if let qrImage = qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Failed to generate QR Code")
                    .foregroundColor(.red)
            }
        }
        .onLoad {
            loadQRCode()
        }
    }
    
    private func loadQRCode() {
        switch input {
        case .string(let string):
            qrImage = QRCodeGenerator.generateQRCode(from: string)
        case .url(let url):
            qrImage = QRCodeGenerator.generateQRCode(from: url)
        case .data(let data):
            qrImage = QRCodeGenerator.generateQRCode(from: data)
        }
    }
    
}

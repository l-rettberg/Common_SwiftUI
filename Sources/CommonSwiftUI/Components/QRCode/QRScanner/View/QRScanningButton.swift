//
//  QRScanningButton.swift
//  CommonSwiftUI
//
//  Created by James Thang on 09/10/2024.
//

import SwiftUI

/// A customizable button for initiating QR code scanning in SwiftUI.
///
/// This view component creates a button designed for QR code scanning functionalities. It incorporates an optional scanning animation and can be styled extensively with colors and custom shapes.
///
/// - Parameters:
///   - color: The foreground color of the QR code icon inside the button.
///   - backgroundColor: The background color of the button.
///   - shape: The shape of the button, conforming to the `Shape` protocol.
///   - showsScanningAnimation: A Boolean that determines whether a scanning animation is shown.
///   - action: The closure executed when the button is tapped.
///
/// ## Example:
/// ```swift
/// @State private var isScanning = false
///
/// var body: some View {
///     QRScanningButton(color: .blue, in: RoundedRectangle(cornerRadius: 12), showsScanningAnimation: isScanning) {
///         isScanning.toggle()
///     }
/// }
/// ```
/// This setup uses a `QRScanningButton` with a rounded rectangle shape, changing state when tapped, triggering a scanning animation.
public struct QRScanningButton<ButtonShape: Shape>: View {
    
    private var color: Color
    private var backgroundColor: Color
    private var shape: ButtonShape
    private var showsScanningAnimation: Bool
    private var action: () -> Void
    
    // View Properties
    @State private var isScanningAnimation: Bool = false
    @State private var showViewfinder = false

    public init(
        color: Color = .blue,
        backgroundColor: Color = Color.gray.opacity(0.2),
        in shape: ButtonShape = .rect(cornerRadius: 12),
        showsScanningAnimation: Bool = true,
        action: @escaping () -> Void
    ) {
        self.color = color
        self.backgroundColor = backgroundColor
        self.shape = shape
        self.showsScanningAnimation = showsScanningAnimation
        self.action = action
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            
            Button(action: action) {
                ZStack(alignment: .top) {
                    Image(systemName: showViewfinder ? "qrcode.viewfinder" : "qrcode")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(color)
                        .padding(size.width * 0.15)
                    
                    if showsScanningAnimation {
                        ScanningRect(size: size)
                    }
                }
                .background(backgroundColor)
                .clipShape(shape)
            }
            .apply {
                if #available(iOS 17.0, *) {
                    $0.contentTransition(.symbolEffect(.replace))
                } else {
                    $0
                }
            }
            .shadow(color: .gray.opacity(0.4), radius: 2, x: 0, y: 2)
            .onAppear {
                if showsScanningAnimation {
                    activateScannerAnimation()
                }
                if #available(iOS 17.0, *) {
                    qrTransitionAnimation()
                }
            }
            .onDisappear {
                if showsScanningAnimation {
                    deactivateScannerAnimation()
                }
            }
        }
    }
    
    @ViewBuilder
    private func ScanningRect(size: CGSize) -> some View {
        Rectangle()
            .fill(color)
            .frame(height: 2.5)
            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: isScanningAnimation ? 15 : -15)
            .offset(y: isScanningAnimation ? size.width : 0)
    }
    
    private func qrTransitionAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                showViewfinder = true
            }
        }
    }
    
    private func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanningAnimation = true
        }
    }
    
    private func deactivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanningAnimation = false
        }
    }
    
}

#Preview {
    VStack(spacing: 24) {
        QRScanningButton(color: .white, backgroundColor: .purple) {
            
        }
        .frame(width: 80, height: 80, alignment: .center)
        
        QRScanningButton(color: .black, backgroundColor: .green, in: .circle) {
            
        }
        .frame(width: 120, height: 120, alignment: .center)
        
        QRScanningButton(color: .white, backgroundColor: .teal) {
            
        }
        .frame(width: 50, height: 50, alignment: .center)
    }
}

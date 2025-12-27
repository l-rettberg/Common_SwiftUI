//
//  ScannerView.swift
//  QRCode_SwiftUI
//
//  Created by James Thang on 09/04/2023.
//

import SwiftUI

/// A robust QR code scanner view for SwiftUI, offering real-time scanning capabilities.
///
/// `QRScannerView` integrates camera functionality to scan QR codes and handle the results dynamically through a completion handler. It supports customization of scanning animation, torch functionality, and error handling.
///
/// - Parameters:
///   - isScanning: A binding to control the scanning process.
///   - showScanningAnimation: A Boolean value that determines whether to show a scanning animation.
///   - scanningTint: The color of the scanning animation.
///   - showTorch: A Boolean value that determines whether to show a torch toggle button.
///   - showErrorAlert: A Boolean value that determines whether to show an alert on scanning errors.
///   - completion: A closure executed with the scanning result, returning a `String` on success or an `Error` on failure.
///
/// ## Example:
/// ```swift
/// @State private var isScanning = false
///
/// var body: some View {
///     QRScannerView(isScanning: $isScanning, showScanningAnimation: true, scanningTint: .blue, showTorch: true, showErrorAlert: true, completion: { result in
///         switch result {
///         case .success(let code):
///             print("Scanned code: \(code)")
///         case .failure(let error):
///             print("Scanning failed: \(error.localizedDescription)")
///         }
///     })
/// }
/// ```
/// This component is designed to provide a seamless integration of QR scanning functionality within your SwiftUI applications, enhancing user interaction and data capture capabilities.
public struct QRScannerView: View {
    
    @Binding private var isScanning: Bool
    @StateObject private var viewModel: QRScannerViewModel
    @StateObject private var torchControl = TorchControl(isOn: false)
    private var showTorch: Bool
    @Environment(\.openURL) private var openURL
    
    public init(isScanning: Binding<Bool>, showScanningAnimation: Bool = true, scanningTint: Color = .blue, showTorch: Bool = false, showErrorAlert: Bool = true, completion: @escaping (Result<String, Error>) -> Void) {
        self._isScanning = isScanning
        self.showTorch = showTorch
        self._viewModel = StateObject(wrappedValue: QRScannerViewModel(
            isScanning: isScanning.wrappedValue,
            showScanningAnimation: showScanningAnimation,
            scanningTint: scanningTint,
            showErrorAlert: showErrorAlert,
            completion: completion))
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                if let session = viewModel.sessionManager?.session {
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: session)
                        .scaleEffect(0.97)
                } else {
                    // Placeholder while session is nil
                    Color.black
                }
                
                if viewModel.showScanningAnimation {
                    ScanningCorners
                }
            }
            // Square Shape
            .frame(width: size.width, height: size.width)
            // Scanner Animation
            .overlay(alignment: .top, content: {
                if viewModel.showScanningAnimation {
                    ScanningRect(size: size)
                }
            })
            .overlay(alignment: .topTrailing, content: {
                if showTorch {
                    TorchButton
                }
            })
            // Make it center
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.checkCameraPermission()
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showError) {
            // show Setting button if permission is Denied
            if viewModel.cameraPermission == .denied {
                Button("Setting") {
                    let setttingsString = UIApplication.openSettingsURLString
                    if let settingsUrl = URL(string: setttingsString) {
                        // Open App Setting, using openAPI SwiftUI
                        openURL(settingsUrl)
                    }
                }
                
                Button("Cancel", role: .cancel) {}
            }
        }
        .onChange(of: isScanning) { newValue in
            viewModel.updateScanningState(newValue)
        }
        .onChange(of: viewModel.isScanning) { newValue in
            isScanning = newValue
        }
        .onDisappear {
            viewModel.sessionManager?.stopRunningInBackground()
        }
    }
    
    @ViewBuilder
    private func ScanningRect(size: CGSize) -> some View {
        Rectangle()
            .fill(viewModel.scanningTint)
            .frame(height: 2.5)
            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: viewModel.isScanningAnimation ? 15 : -15)
            .offset(y: viewModel.isScanningAnimation ? size.width : 0)
    }
    
    private var ScanningCorners: some View {
        ForEach(0...4, id: \.self) { index in
            RoundedRectangle(cornerRadius: 2, style: .circular)
            // Trimming to get Scanner like Edges
                .trim(from: 0.61, to: 0.64)
                .stroke(viewModel.scanningTint, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(Double(index * 90)))
        }
    }
    
    private var TorchButton: some View {
        Button(action: {
            torchControl.isOn.toggle()
        }) {
            Image(systemName: torchControl.isOn ? "bolt.slash" : "bolt.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(torchControl.isOn ? .gray : .white)
                .padding(8)
                .background(.ultraThinMaterial, in: .circle)
        }
        .padding()
    }
    
}


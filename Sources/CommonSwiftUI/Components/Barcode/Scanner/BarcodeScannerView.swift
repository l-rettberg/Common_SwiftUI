//
//  BarcodeScannerView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 23/09/2024.
//

import SwiftUI
import AVFoundation
import UIKit

/// A SwiftUI view component that implements a barcode scanner with comprehensive features.
///
/// The `BarcodeScannerView` uses the device's camera to scan and recognize barcodes, handling various supported barcode types. It offers customizable UI elements such as scanning animation, torch toggle, and error handling.
///
/// - Parameters:
///   - isScanning: A binding to a Boolean that controls whether the scanner is active.
///   - showScanningAnimation: A Boolean indicating whether a scanning animation should be shown.
///   - scanningTint: The color of the scanning animation.
///   - showTorch: A Boolean that indicates whether a torch toggle should be shown to assist scanning in low light conditions.
///   - showErrorAlert: A Boolean to toggle the display of an error alert.
///   - completion: A closure that is called with the result of the scan, either successful with a scanned code or an error.
///
/// ## Usage:
/// ```swift
/// @State private var isScanning = false
///
/// var body: some View {
///     BarcodeScannerView(isScanning: $isScanning, showScanningAnimation: true, scanningTint: .blue, showTorch: true, showErrorAlert: true) { result in
///         switch result {
///         case .success(let code):
///             print("Scanned code: \(code)")
///         case .failure(let error):
///             print("Scanning failed with error: \(error)")
///         }
///     }
/// }
/// ```
///
/// This component requires camera access and will prompt the user if permission has not already been granted. It supports a range of barcode types including QR, EAN8, EAN13, and more.
public struct BarcodeScannerView: View {
    
    @Binding private var isScanning: Bool
    @StateObject private var viewModel: BarcodeScannerViewModel
    @StateObject private var torchControl = TorchControl(isOn: false)
    private var showTorch: Bool
    @Environment(\.openURL) private var openURL
    
    public init(isScanning: Binding<Bool>, showScanningAnimation: Bool = true, scanningTint: Color = .blue, showTorch: Bool = false, showErrorAlert: Bool = true, completion: @escaping (Result<String, Error>) -> Void) {
        self._isScanning = isScanning
        self.showTorch = showTorch
        self._viewModel = StateObject(wrappedValue: BarcodeScannerViewModel(
            isScanning: isScanning.wrappedValue,
                    showScanningAnimation: showScanningAnimation,
                    scanningTint: scanningTint,
                    showErrorAlert: showErrorAlert,
                    completion: completion))
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            ZStack {
                if let session = viewModel.sessionManager?.session {
                    CameraView(frameSize: CGSize(width: size.width, height: size.height), session: session)
                        .accessibilityLabel("Barcode Scanner")
                        .accessibilityHint("Position a barcode within the frame to scan it.")
                } else {
                    Color.black // Placeholder while session is nil
                }
            }
            .frame(width: size.width, height: size.height)
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
            // Show Settings button if permission is Denied
            if viewModel.cameraPermission == .denied {
                Button("Settings") {
                    let settingsString = UIApplication.openSettingsURLString
                    if let settingsUrl = URL(string: settingsString) {
                        // Open App Settings using openURL SwiftUI environment
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
        .accessibilityElement(children: .contain)
    }
    
    @ViewBuilder
    private func ScanningRect(size: CGSize) -> some View {
        Rectangle()
            .fill(viewModel.scanningTint)
            .frame(height: 2.5)
            .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: viewModel.isScanningAnimation ? 15 : -15)
            .offset(y: viewModel.isScanningAnimation ? size.height : 0)
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



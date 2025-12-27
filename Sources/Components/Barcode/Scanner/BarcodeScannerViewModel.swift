//
//  BarcodeScannerViewModel.swift
//  CommonSwiftUI
//
//  Created by James Thang on 03/10/2024.
//

import SwiftUI
import AVFoundation
import Combine

@MainActor
final class BarcodeScannerViewModel: ObservableObject {
    
    @Published private(set) var isScanning: Bool
    @Published private(set) var isScanningAnimation: Bool = false
    @Published private(set) var sessionManager: CameraSessionManager?
    @Published private(set) var cameraPermission: Permission = .idle
    @Published private(set) var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published private var barcodeDelegate = BarcodeScannerDelegate()
    
    private var metadataOutput: AVCaptureMetadataOutput = .init()
    private var completion: (Result<String, Error>) -> Void
    private(set) var showScanningAnimation: Bool
    private(set) var scanningTint: Color
    private var showErrorAlert: Bool
    
    // Define Supported Barcode Types
    private let supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr, .ean8, .ean13, .code128, .code39, .upce, .pdf417, .aztec, .dataMatrix, .itf14]
    
    private var cancellables = Set<AnyCancellable>()
    
    init(isScanning: Bool, showScanningAnimation: Bool = true, scanningTint: Color = .blue, showErrorAlert: Bool = true, completion: @escaping (Result<String, Error>) -> Void) {
        self.isScanning = isScanning
        self.showScanningAnimation = showScanningAnimation
        self.scanningTint = scanningTint
        self.showErrorAlert = showErrorAlert
        self.completion = completion
        
        setupBindings()
    }
    
    private func setupBindings() {
        // Observe barcodeDelegate.scannedBarcode
        barcodeDelegate.$scannedBarcode
            .compactMap { $0 } // Ignore nil values
            .sink { [weak self] scanned in
                self?.handleScannedCode(scanned.value)
            }
            .store(in: &cancellables)
        
        // Observe isScanning changes
        $isScanning
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.handleScanningStateChange(isScanning: newValue)
            }
            .store(in: &cancellables)
    }
    
}

//MARK: - Camera Setup
extension BarcodeScannerViewModel {
    
    func checkCameraPermission() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermission = .approved
            if sessionManager == nil {
                // New Setup
                await setupCamera()
            } else {
                sessionManager?.startRunningInBackground()
            }
        case .notDetermined:
            // Requesting Camera Access
            if await AVCaptureDevice.requestAccess(for: .video) {
                // Permission Granted
                cameraPermission = .approved
                await setupCamera()
            } else {
                // Permission Denied
                cameraPermission = .denied
                // Presenting Error Message
                presentError(CameraAccessError.cameraPermissionDenied.errorDescription)
                completion(.failure(CameraAccessError.cameraPermissionDenied))
            }
        case .denied, .restricted:
            cameraPermission = .denied
            presentError(CameraAccessError.cameraPermissionDenied.errorDescription)
            completion(.failure(CameraAccessError.cameraPermissionDenied))
        default:
            completion(.failure(CameraAccessError.unknownPermission))
        }
    }
    
    private func setupCamera() async {
        do {
            // Attempt to find the back wide-angle camera
            var device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .back
            ).devices.first
            
            // Fallback to default video device if specific camera not found
            if device == nil {
                device = AVCaptureDevice.default(for: .video)
            }
            
            // Handle if no camera is found
            guard let cameraDevice = device else {
                presentError(CameraAccessError.unknownDevice.errorDescription)
                completion(.failure(CameraAccessError.unknownDevice))
                return
            }
            
            // Camera Input
            let input = try AVCaptureDeviceInput(device: cameraDevice)
            
            // Create a new AVCaptureSession
            let session = AVCaptureSession()
            
            // Checking whether input can be added to the session
            guard session.canAddInput(input) else {
                presentError(CameraAccessError.unknownInputOutput.errorDescription)
                completion(.failure(CameraAccessError.unknownInputOutput))
                return
            }
            
            // Adding input and output to Camera session
            session.beginConfiguration()
            session.addInput(input)
            session.commitConfiguration()
            
            // Initialize the sessionManager with the session and supported types
            sessionManager = CameraSessionManager(session: session)
            
            if session.canAddOutput(metadataOutput) {
                session.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(barcodeDelegate, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = supportedBarcodeTypes
            } else {
                throw CameraAccessError.unknownInputOutput
            }
            
            if isScanning {
                // Start the session on a background thread
                sessionManager?.startRunningInBackground()
                // Animation
                activateScannerAnimation()
            }
            
        } catch {
            presentError(error.localizedDescription)
            completion(.failure(error))
        }
    }
    
}

//MARK: - Scanning Logic
extension BarcodeScannerViewModel {
    
    func updateScanningState(_ newValue: Bool) {
        self.isScanning = newValue
    }
    
    private func handleScannedCode(_ code: String) {
        completion(.success(code))
        sessionManager?.stopRunningInBackground()
        deactivateScannerAnimation()
        barcodeDelegate.scannedBarcode = nil
        isScanning = false
    }
    
    private func handleScanningStateChange(isScanning: Bool) {
        if isScanning {
            if let sessionManager, !sessionManager.isRunning, cameraPermission == .approved {
                sessionManager.startRunningInBackground()
                activateScannerAnimation()
            }
        } else {
            sessionManager?.stopRunningInBackground()
            deactivateScannerAnimation()
            barcodeDelegate.scannedBarcode = nil
        }
    }
    
}


//MARK: - Error Handling
extension BarcodeScannerViewModel {
    
    private func presentError(_ message: String) {
        if !showErrorAlert { return }
        errorMessage = message
        showError.toggle()
    }
    
}

//MARK: - Animation
extension BarcodeScannerViewModel {
    
    private func activateScannerAnimation() {
        if showScanningAnimation {
            withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
                isScanningAnimation = true
            }
        }
    }
    
    private func deactivateScannerAnimation() {
        if showScanningAnimation {
            withAnimation(.easeInOut(duration: 0.85)) {
                isScanningAnimation = false
            }
        }
    }
    
}

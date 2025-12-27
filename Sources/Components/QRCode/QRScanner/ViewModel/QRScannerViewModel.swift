//
//  QRScannerViewModel.swift
//  CommonSwiftUI
//
//  Created by James Thang on 03/10/2024.
//

import SwiftUI
import AVFoundation
import Combine

@MainActor
final class QRScannerViewModel: ObservableObject {
    
    @Published private(set) var isScanning: Bool
    // QR Code Scanner Properties
    @Published private(set) var isScanningAnimation: Bool = false
    @Published private(set) var sessionManager: CameraSessionManager?
    @Published private(set) var cameraPermission: Permission = .idle
    
    // Error properties
    @Published private(set) var errorMessage: String = ""
    @Published var showError: Bool = false
    
    // Camera QR Output Delegate
    @Published private(set) var qrDelegate = QRScannerDelegate()
    
    // Private properties
    // QR Scanner AV Output
    private var qrOutput: AVCaptureMetadataOutput = .init()
    private(set) var completion: (Result<String, Error>) -> Void
    private(set) var showScanningAnimation: Bool
    private(set) var scanningTint: Color
    private var showErrorAlert: Bool
    
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
        // Observe qrDelegate.scannedQRCode
        qrDelegate.$scannedQRCode
            .compactMap { $0 } // Ignore nil values
            .sink { [weak self] code in
                self?.handleScannedCode(code)
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
extension QRScannerViewModel {
    
    func checkCameraPermission() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermission = .approved
            if sessionManager == nil {
                await setupCamera()
            } else {
                sessionManager?.startRunningInBackground()
            }
        case .notDetermined:
            // Requesting Camera Access
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                // Permission Granted
                cameraPermission = .approved
                await setupCamera()
            } else {
                // Permission Denied
                cameraPermission = .denied
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
            // Finding back camera
            var device = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .back
            ).devices.first
            
            // If not found, fall back to the default video device
            if device == nil {
                device = AVCaptureDevice.default(for: .video)
            }
            
            // Handle if no back camera is found
            guard let device else {
                presentError(CameraAccessError.unknownDevice.errorDescription)
                completion(.failure(CameraAccessError.unknownDevice))
                return
            }
            
            // Camera Input
            let input = try AVCaptureDeviceInput(device: device)
            
            // Create a new AVCaptureSession
            let session = AVCaptureSession()
            
            // For extra safety
            // Checking whether input & output can be added to the session
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError(CameraAccessError.unknownInputOutput.errorDescription)
                completion(.failure(CameraAccessError.unknownInputOutput))
                return
            }
            
            // Adding input and output to Camera session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            // Setting output config to read QR code
            qrOutput.metadataObjectTypes = [.qr]
            // Adding Delegate to Retreive the fetched QR code from the Camera
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            
            // Initialize the sessionManager with the session
            sessionManager = CameraSessionManager(session: session)
            
            if isScanning {
                // Note session must be started on Background thread
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
extension QRScannerViewModel {
 
    func updateScanningState(_ newValue: Bool) {
        self.isScanning = newValue
    }
    
    private func handleScannedCode(_ code: String) {
        completion(.success(code))
        sessionManager?.stopRunningInBackground()
        deactivateScannerAnimation()
        qrDelegate.scannedQRCode = nil
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
            qrDelegate.scannedQRCode = nil
        }
    }
    
}

//MARK: - Animation
extension QRScannerViewModel {
    
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

//MARK: - Error Handling
extension QRScannerViewModel {
    
    private func presentError(_ message: String) {
        if !showErrorAlert { return }
        errorMessage = message
        showError.toggle()
    }
    
}

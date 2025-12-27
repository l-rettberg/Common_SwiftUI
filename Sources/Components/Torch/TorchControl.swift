//
//  TorchControl.swift
//  CommonSwiftUI
//
//  Created by James Thang on 27/09/2024.
//

import SwiftUI
import AVFoundation
import Combine

/// Manages the torch mode on a device with camera capabilities.
///
/// `TorchControl` provides an interface to toggle the torch (flashlight) of a device's camera on or off. It reacts to changes in the `isOn` property to control the torch state.
///
/// - Properties:
///   - isOn: A `Bool` that indicates whether the torch should be on or off.
///
/// ## Example Usage:
/// ```swift
/// @StateObject var torchState = TorchControl(isOn: false)
///
/// var body: some View {
///     VStack {
///         Toggle(isOn: $torchState.isOn) {
///             Text("Torch Mode")
///         }
///         Button(action: {
///             torchState.isOn.toggle()
///         }) {
///             Text("Toggle Torch")
///         }
///     }
/// }
/// ```
///
/// This class utilizes `AVCaptureDevice` to manage the torch settings and handles configuration and error states internally. Ensure that the device has a torch and the app has the necessary permissions to use the camera.
@MainActor
public class TorchControl: ObservableObject {
    
    @Published public var isOn: Bool {
        didSet {
            Task {
                await toggleTorch(isOn)
            }
        }
    }
    
    public init(isOn: Bool) {
        self.isOn = isOn
        Task {
            await toggleTorch(isOn)
        }
    }
    
    private func toggleTorch(_ isOn: Bool) async {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            defer { device.unlockForConfiguration() }
            
            if isOn {
                try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
            } else {
                device.torchMode = .off
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
}

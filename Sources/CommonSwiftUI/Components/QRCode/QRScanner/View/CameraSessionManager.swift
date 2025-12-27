//
//  CameraSessionManager.swift
//  CommonSwiftUI
//
//  Created by James Thang on 20/09/2024.
//

import AVFoundation

class CameraSessionManager {
    
    let session: AVCaptureSession
    
    var isRunning: Bool {
        return session.isRunning
    }

    init(session: AVCaptureSession) {
        self.session = session
    }

    private func startRunning() {
        session.startRunning()
    }

    private func stopRunning() {
        session.stopRunning()
    }

    func startRunningInBackground() {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.session.isRunning {
                self.startRunning()
            }
        }
    }
    
    func stopRunningInBackground() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.stopRunning()
            }
        }
    }
    
}

//
//  CameraView.swift
//  QRCode_SwiftUI
//
//  Created by James Thang on 09/04/2023.
//

import SwiftUI
import AVKit

// Camera View using AVCaptureVideoPreviewLayer
struct CameraView: UIViewRepresentable {
    
    var frameSize: CGSize
    var session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: CGRect(origin: .zero, size: frameSize))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = CGRect(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the frame if needed
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = CGRect(origin: .zero, size: frameSize)
        }
    }
    
}

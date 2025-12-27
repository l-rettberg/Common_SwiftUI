//
//  BarcodeScannerDelegate.swift
//  CommonSwiftUI
//
//  Created by James Thang on 23/09/2024.
//

import SwiftUI
import AVFoundation

class BarcodeScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    
    @Published var scannedBarcode: ScannedBarcode?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metaObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = metaObject.stringValue else { return }
        
        let type = metaObject.type
        // Ensure updates happen on the main thread
        DispatchQueue.main.async {
            self.scannedBarcode = ScannedBarcode(type: type, value: code)
        }
    }
    
}

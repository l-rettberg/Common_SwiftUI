//
//  CameraScannerViewController.swift
//  CommonSwiftUI
//
//  Created by James Thang on 04/09/2023.
//

import Foundation
import SwiftUI
import UIKit
import VisionKit

@available(iOS 16.0, *)
public struct CameraScannerVisionKit: UIViewControllerRepresentable {

    public var completion: (Result<String, Error>) -> Void
    @Binding var stopScanning: Bool

    public init(stopScanning: Binding<Bool>, completion: @escaping (Result<String, Error>) -> Void) {
        self._stopScanning = stopScanning
        self.completion = completion
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> DataScannerViewController {
        let viewController = DataScannerViewController (
            recognizedDataTypes: [.barcode()],
                qualityLevel: .accurate,
                recognizesMultipleItems: false,
                isHighFrameRateTrackingEnabled: false,
                isPinchToZoomEnabled: true,
                isGuidanceEnabled: false,
                isHighlightingEnabled: false)
        viewController.delegate = context.coordinator
        return viewController
    }

    public func updateUIViewController(_ viewController: DataScannerViewController, context: Context) {
        try? viewController.startScanning ()
        NSLog("Scanner started")
    }

    public static func dismantleUIViewController(_ viewController: DataScannerViewController, coordinator: Coordinator) {
        viewController.stopScanning()
    }

    public class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: CameraScannerVisionKit
        init (_ parent: CameraScannerVisionKit) {
            self.parent = parent
        }
        
        public func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            guard let firstItem = allItems.first else { return }
            if parent.stopScanning { return }
            switch firstItem {
            case.barcode(let data):
                dataScanner.stopScanning()
                parent.stopScanning = true
                parent.completion(.success(data.payloadStringValue ?? ""))
            default:
                break
            }
        }
    }
}

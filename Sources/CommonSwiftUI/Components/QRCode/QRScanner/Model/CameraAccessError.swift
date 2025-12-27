//
//  QRScannerError.swift
//  CommonSwiftUI
//
//  Created by James Thang on 04/08/2024.
//

import Foundation

enum CameraAccessError: Error, LocalizedError {
    case cameraPermissionDenied
    case unknownPermission
    case unknownDevice
    case unknownInputOutput

    var errorDescription: String {
        switch self {
        case .cameraPermissionDenied:
            return NSLocalizedString("Camera permission denied.", comment: "Camera Permission Denied")
        case .unknownPermission:
            return NSLocalizedString("Unknown permission error.", comment: "Unknown Permission Error")
        case .unknownDevice:
            return NSLocalizedString("Unknown device error.", comment: "Unknown Device Error")
        case .unknownInputOutput:
            return NSLocalizedString("Unknown input/output error.", comment: "Unknown Input/Output Error")
        }
    }
}

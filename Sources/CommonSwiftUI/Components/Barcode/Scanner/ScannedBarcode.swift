//
//  ScannedBarcode.swift
//  CommonSwiftUI
//
//  Created by James Thang on 23/09/2024.
//

import Foundation
import AVFoundation

struct ScannedBarcode: Equatable {
    let type: AVMetadataObject.ObjectType
    let value: String
}

//
//  QRCodeInputType.swift
//  CommonSwiftUI
//
//  Created by James Thang on 23/08/2024.
//

import Foundation

/// Defines the types of inputs that can be used to generate a QR code in `QRGeneratorView`.
///
/// `QRCodeInputType` is an enumeration that facilitates the specification of the source data for QR code generation. It supports three different types of inputs:
/// - `string`: A simple string to be encoded into a QR code.
/// - `url`: A URL object representing a web address.
/// - `data`: Arbitrary data, such as binary encoded information.
///
/// This enumeration simplifies the process of selecting and processing different kinds of data to generate a QR code.
/// 
public enum QRCodeInputType {
    case string(String)
    case url(URL)
    case data(Data)
}

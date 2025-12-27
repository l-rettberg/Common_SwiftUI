//
//  ValidationTextField+EnvironmentKey.swift
//  CommonSwiftUI
//
//  Created by James Thang on 08/06/2024.
//

import SwiftUI

struct ValidationTextFieldClearButtonHidden: EnvironmentKey {
    static var defaultValue: Bool = true
}

struct ValidationTextFieldSecureButtonHidden: EnvironmentKey {
    static var defaultValue: Bool = true
}

struct ValidationTextFieldMandatory: EnvironmentKey {
    static var defaultValue: (Bool, String) = (false, "")
}

struct ValidationTextFieldValidationHandler: EnvironmentKey {
    static var defaultValue: ((String) -> Result<String, Error>)?
}

struct FormValidationTextFieldValidationHandler: EnvironmentKey {
    static var defaultValue: ((String) -> [ValidationTextField.FormValidationElement])?
}

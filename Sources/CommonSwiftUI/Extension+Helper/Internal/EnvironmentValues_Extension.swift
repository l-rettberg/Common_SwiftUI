//
//  EnvironmentValues_Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 08/06/2024.
//

import SwiftUI

extension EnvironmentValues {
    
    var clearButtonHidden: Bool {
        get { self[ValidationTextFieldClearButtonHidden.self] }
        set { self[ValidationTextFieldClearButtonHidden.self] = newValue }
    }
    
    var secureButtonHidden: Bool {
        get { self[ValidationTextFieldSecureButtonHidden.self] }
        set { self[ValidationTextFieldSecureButtonHidden.self] = newValue }
    }
    
    var isMandatory: (Bool, String) {
        get { self[ValidationTextFieldMandatory.self] }
        set { self[ValidationTextFieldMandatory.self] = newValue }
    }
    
    var validationHandler: ((String) -> Result<String, Error>)? {
        get { self[ValidationTextFieldValidationHandler.self] }
        set { self[ValidationTextFieldValidationHandler.self] = newValue }
    }
    
    var formValidationHandler: ((String) -> [ValidationTextField.FormValidationElement])? {
        get { self[FormValidationTextFieldValidationHandler.self] }
        set { self[FormValidationTextFieldValidationHandler.self] = newValue }
    }
    
}

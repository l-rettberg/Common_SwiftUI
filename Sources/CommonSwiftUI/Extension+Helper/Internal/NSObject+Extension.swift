//
//  NSObject+Extension.swift
//  CommonSwiftUI
//
//  Created by James Thang on 28/03/2024.
//

import Foundation

extension NSObject {
    // Key Value from NSObject
    var values: [String : Any]? {
        get {
            return value(forKeyPath: "requestedValues") as? [String : Any]
        }
        set
        {
            setValue(newValue, forKeyPath: "requestedValues")
        }
    }
    
    func value(key: String, filter: String) -> NSObject? {
        (value(forKey: key) as? [NSObject])?.first(where: { obj in
            return obj.value(forKeyPath: "filterType") as? String == filter
        })
    }
}

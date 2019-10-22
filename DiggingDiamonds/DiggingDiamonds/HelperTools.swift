//
//  HelperTools.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation

/// Get value from dictionary if key already exists. If key does not exist, use closure to create value, put it into dictionary and return it.
/// The algorithm guarantees, that
///  - Key in dictionary is located only once
///  - New value is only created, if none exists, yet
internal extension Dictionary {
    mutating func getAndAddIfNotExisting(key: Key, closure: (Key) -> Value) -> Value {
        if let value = self[key] {
            return value
        } else {
            let value = closure(key)
            self[key] = value
            return value
        }
    }
}

/// Allows formatting a Double in String-interpolation, e.g. \(<#some double var#>.format(".2")
internal extension Double {
    func format(_ format: String) -> String {
        return String(format: "%\(format)f", self)
    }
}

//
//  HelperTools.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/// Get value from dictionary if key already exists. If key does not exist, use closure to create value, put it into dictionary and return it.
/// The algorithm guarantees, that
///  - Key in dictionary is located only once
///  - New value is only created, if none exists, yet
public extension Dictionary {
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
public extension Double {
    func format(_ format: String) -> String {
        return String(format: "%\(format)f", self)
    }
}

/// Handle errors.
/// Returns true, if check was succesful, false if error occured
internal func check(storeDescription: NSPersistentStoreDescription? = nil, error: Error?) -> Bool {
    if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        print("*** Unresolved error \(error), \(error.userInfo)")
        fatalError("Unresolved error \(error), \(error.userInfo)")
    }
    return true
}

public func getUrlAction(_ url: String) -> () -> Void {
    if let url = URL(string: url) {
        return {UIApplication.shared.open(url)}
    } else {
        return {} // Do nothing
    }
}

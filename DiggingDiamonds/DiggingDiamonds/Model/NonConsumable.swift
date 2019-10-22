//
//  NonConsumable.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData

class NonConsumable: ObservableObject {
    internal var delegate: GTNonConsumable {
           didSet(prev) {
               guard prev != delegate else {return}
               if let context = delegate.managedObjectContext {
                   context.delete(prev)
                   merge(prev: prev)
               }
           }
       }
    
    /// Current score
    @Published private(set) var isOpened: Bool
    
    internal init(delegate: GTNonConsumable) {
        self.delegate = delegate
        self.isOpened = delegate.isOpened
    }
      
    // init from new instance
    internal convenience init(_ id: String, context: NSManagedObjectContext) {
        self.init(delegate: NSEntityDescription.insertNewObject(forEntityName: "NonConsumable", into: context) as! GTNonConsumable)
        delegate.id = id
    }

    /// Earn (increment) some score
    public func unlock() {
        isOpened = true
    }
    
    internal func prepareForSave() {
        delegate.isOpened = isOpened
    }
    
    internal func merge(prev: GTNonConsumable) {
      isOpened = (delegate.isOpened || prev.isOpened)
    }
}

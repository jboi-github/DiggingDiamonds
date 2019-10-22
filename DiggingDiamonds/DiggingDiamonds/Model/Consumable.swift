//
//  Consumable.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData

class Consumable: ObservableObject {
    internal var delegate: GTConsumable {
           didSet(prev) {
               guard prev != delegate else {return}
               if let context = delegate.managedObjectContext {
                   context.delete(prev)
                   merge(prev: prev)
               }
           }
       }
     
    /// Currently available goods from bought, earned and consumed
    @Published private(set) var available: Int
    
    // Published var cannot be a calculated property, so need to trigger here
    private var earned: Int {didSet {available = earned + bought - consumed}}
    private var bought: Int {didSet {available = earned + bought - consumed}}
    private var consumed: Int {didSet {available = earned + bought - consumed}}

    internal init(delegate: GTConsumable) {
        self.delegate = delegate
        self.earned = Int(delegate.earned)
        self.bought = Int(delegate.bought)
        self.consumed = Int(delegate.consumed)
        available = earned + bought - consumed
    }
      
    // init from new instance
    internal convenience init(_ id: String, context: NSManagedObjectContext) {
        self.init(delegate: NSEntityDescription.insertNewObject(forEntityName: "Consumable", into: context) as! GTConsumable)
        delegate.id = id
    }

    /// Earn (increment) consumable
    public func earn(_ earned: Int) {self.earned += earned}
     
    /// Buy (increment) consumable
    public func buy(_ bought: Int) {self.bought += bought}
     
    /// Consume (decrement) consumable
    public func consume(_ consumed: Int) {self.consumed += consumed}
     
    internal func prepareForSave() {
        delegate.earned = Int64(earned)
        delegate.bought = Int64(bought)
        delegate.consumed = Int64(consumed)
    }
    
    internal func merge(prev: GTConsumable) {
        earned = Int(max(delegate.earned, prev.earned))
        bought = Int(max(delegate.bought, prev.bought))
        consumed = Int(max(delegate.consumed, prev.consumed))
    }
}

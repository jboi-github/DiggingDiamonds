//
//  Achievement.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData

class Achievement: ObservableObject {
    internal var delegate: GTAchievement {
           didSet(prev) {
               guard prev != delegate else {return}
               if let context = delegate.managedObjectContext {
                   context.delete(prev)
                   merge(prev: prev)
               }
           }
       }
    
    /// Current achievement up to 100%
    @Published private(set) var current: Double
    
    /// Personal highest achievement
    @Published private(set) var highest: Double
    
    /// Times, the achievement was reached
    @Published private(set) var timesAchieved: Int
    
    // init from load
    internal init(delegate: GTAchievement) {
        self.delegate = delegate
        self.current = delegate.current
        self.highest = delegate.highest
        self.timesAchieved = Int(delegate.current)
    }
    
    // init from new instance
    internal convenience init(_ id: String, context: NSManagedObjectContext) {
        self.init(delegate: NSEntityDescription.insertNewObject(forEntityName: "Achievement", into: context) as! GTAchievement)
        delegate.id = id
    }
    
    /// Adjust achievement
    public func achieved(_ current: Double) {
        self.current = current
        if current > highest {highest = current}
        timesAchieved = Int(current) // Round down
    }
    
    /// Restart score at 0, e.g. when new level or new game starts
    public func startOver() {current = 0}
    
    internal func prepareForSave() {
        delegate.current = current
        delegate.highest = highest
    }
    
    internal func merge(prev: GTAchievement) {
        current = Double(delegate.current)
        highest = Double(max(delegate.highest, prev.highest))
    }
}

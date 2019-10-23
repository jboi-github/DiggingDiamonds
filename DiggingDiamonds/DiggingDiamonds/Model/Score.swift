//
//  GTScore.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData
import GameKit

internal class Score: ObservableObject {
    internal var delegate: GTScore {
        didSet(prev) {
            guard prev != delegate else {return}
            if let context = delegate.managedObjectContext {
                context.delete(prev)
                merge(prev: prev)
            }
        }
    }
    
    /// Current score
    @Published private(set) var current: Int
    
    /// Personal high score
    @Published private(set) var highest: Int
    
    internal init(delegate: GTScore) {
        self.delegate = delegate
        self.current = Int(delegate.current)
        self.highest = Int(delegate.highest)
    }
    
    // init from new instance
    internal convenience init(_ id: String, context: NSManagedObjectContext) {
        self.init(delegate: NSEntityDescription.insertNewObject(forEntityName: "Score", into: context) as! GTScore)
        delegate.id = id
    }

    /// Earn (increment) some score
    public func earn(_ score: Int) {
        current += score
        if current > highest {highest = current}
    }
    
    /// Restart score at 0, e.g. when new level or new game starts
    public func startOver() {current = 0}
    
    internal func prepareForSave() {
        delegate.current = Int64(current)
        delegate.highest = Int64(highest)
    }
    
    internal func getGameCenterReporter(id: String) -> GKScore {
        let gkScore = GKScore(leaderboardIdentifier: id)
        gkScore.value = Int64(current)
        return gkScore
    }

    internal func merge(prev: GTScore) {
        current = Int(delegate.current)
        highest = Int(max(delegate.highest, prev.highest))
    }
}

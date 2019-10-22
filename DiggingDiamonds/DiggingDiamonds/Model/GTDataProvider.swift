//
//  CoreDataProvider.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData

class GTDataProvider {
    // MARK: - Lifecycle: Get singleton instance for container and save
    private(set) static var sharedInstance: GTDataProvider? = nil
    
    /// Get the shared, singleton instance of Data Provider
    public class func createSharedInstance(containerName: String) {
        if sharedInstance == nil {
            sharedInstance = GTDataProvider(containerName)
        }
     }
    
    /// Save context. To be used in SceneDelegate
    public func save() {
        // Call prepare save on all elements
        achievements.forEach { (key: String, value: Achievement) in value.prepareForSave()}
        scores.forEach { (key: String, value: Score) in value.prepareForSave()}
        nonConsumables.forEach { (key: String, value: NonConsumable) in value.prepareForSave()}
        consumables.forEach { (key: String, value: Consumable) in value.prepareForSave()}

        // Save the context
        guard delegate.viewContext.hasChanges else {return}
        do {
            try delegate.viewContext.save()
        } catch {
            guard check(error: error) else {return}
        }
    }

    // MARK: - Get an entity
    private var achievements = [String:Achievement]()
    private var scores = [String:Score]()
    private var nonConsumables = [String:NonConsumable]()
    private var consumables = [String:Consumable]()
    
    public func getAchievement(_ id: String) -> Achievement {
        achievements.getAndAddIfNotExisting(key: id) {
            (id) -> Achievement in
            Achievement(id, context: delegate.viewContext)
        }
    }
    
    public func getScore(_ id: String) -> Score {
        return scores.getAndAddIfNotExisting(key: id) {
            (id) -> Score in
            return Score(id, context: delegate.viewContext)
        }
    }
    
    public func getNonConsumable(_ id: String) -> NonConsumable {
        nonConsumables.getAndAddIfNotExisting(key: id) {
            (id) -> NonConsumable in
            NonConsumable(id, context: delegate.viewContext)
        }
    }
    
    public func getConsumable(_ id: String) -> Consumable {
        consumables.getAndAddIfNotExisting(key: id) {
            (id) -> Consumable in
            Consumable(id, context: delegate.viewContext)
        }
    }

    // MARK: - Internal, initialize and load data. Keep track of changes
    private let delegate: NSPersistentCloudKitContainer
    
    private init(_ containerName: String) {
        // MARK: Create instance
        delegate = NSPersistentCloudKitContainer(name: containerName)
        delegate.loadPersistentStores() {
            (storeDescription, error) in
            
            guard self.check(storeDescription: storeDescription, error: error) else {return}
            self.delegate.viewContext.automaticallyMergesChangesFromParent = true
        }
        
        // MARK: Fetch data and keep track of changes
        self.load()
    }
 
    /// Load context.
    private func load() {
        load(request: GTScore.fetchRequest()) {
            (element) in

            guard let score = element as? GTScore else {return}
            guard let id = score.id else {return}
            scores.getAndAddIfNotExisting(key: id, closure: {_ in Score(delegate: score)}).delegate = score
        }
        load(request: GTAchievement.fetchRequest()) {
            (element) in
            
            guard let achievement = element as? GTAchievement else {return}
            guard let id = achievement.id else {return}
            achievements.getAndAddIfNotExisting(key: id, closure: {_ in Achievement(delegate: achievement)}).delegate = achievement
        }
        load(request: GTConsumable.fetchRequest()) {
            (element) in
            
            guard let consumable = element as? GTConsumable else {return}
            guard let id = consumable.id else {return}
            consumables.getAndAddIfNotExisting(key: id, closure: {_ in Consumable(delegate: consumable)}).delegate = consumable
        }
        load(request: GTNonConsumable.fetchRequest()) {
            (element) in
            
            guard let nonConsumable = element as? GTNonConsumable else {return}
            guard let id = nonConsumable.id else {return}
            nonConsumables.getAndAddIfNotExisting(key: id, closure: {_ in NonConsumable(delegate: nonConsumable)}).delegate = nonConsumable
        }
    }
 
    private func load(request: NSFetchRequest<NSFetchRequestResult>, map: (NSFetchRequestResult) -> Void) {
         do {
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)] // It simply needs one
            let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: delegate.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            controller.delegate = incorporateChanges
            try controller.performFetch()
            if let fetched = controller.fetchedObjects {
                fetched.forEach {element in map(element)}
            }
        } catch {
            guard check(error: error) else {return}
        }
    }

    /// Handle errors.
    /// Returns true, if check was succesful, false if error occured
    private func check(storeDescription: NSPersistentStoreDescription? = nil, error: Error?) -> Bool {
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
    
    private let incorporateChanges = IncorporateChanges()
    
    private class IncorporateChanges: NSObject, NSFetchedResultsControllerDelegate {
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            print("*** CHANGES DETECTED. Reloading")
            if let provider = GTDataProvider.sharedInstance {provider.load()}
        }
    }
}

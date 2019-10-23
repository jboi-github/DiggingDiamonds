//
//  CoreDataProvider.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI
import GameKit

// MARK: - Central objects to handle
fileprivate var achievements = [String:Achievement]()
fileprivate var scores = [String:Score]()
fileprivate var nonConsumables = [String:NonConsumable]()
fileprivate var consumables = [String:Consumable]()

// MARK: iCloud and CoreData
class GTDataProvider {
    // MARK: Lifecycle: Get singleton instance for container and save
    private(set) static var sharedInstance: GTDataProvider? = nil
    
    /// Get the shared, singleton instance of Data Provider
    public class func createSharedInstance<Label : View>(_ scene: UIScene, containerName: String, makeContentView: () -> Label) {
        
        // Use a UIHostingController as window root view controller.
        guard let windowScene = scene as? UIWindowScene else {return}
        let window = UIWindow(windowScene: windowScene)
        GTGameCenter.createSharedInstance(window: window)

        // Cascade if first time
        if sharedInstance == nil {
            sharedInstance = GTDataProvider(containerName)
        }

        window.rootViewController = UIHostingController(rootView: makeContentView())
        window.makeKeyAndVisible()
    }
    
    public class func createSharedInstanceForPreview(containerName: String) {
        GTGameCenter.createSharedInstanceForPreview()
        if sharedInstance == nil {
            sharedInstance = GTDataProvider(containerName)
        }
    }

    /// Prepare scores to enter new level
    public func enterLevel() {
        scores.forEach {
            (key: String, value: Score) in
            value.startOver()
        }
    }

    /// Make sure GameCenter is reported and data saved
    public func leaveLevel() {
        save()
        GTGameCenter.sharedInstance!.report()
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
        
        // Save to GameCenter
        GTGameCenter.sharedInstance!.report()
    }

    // MARK: Get an entity
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

    // MARK: Internal, initialize and load data. Keep track of changes
    private let delegate: NSPersistentCloudKitContainer
    
    private init(_ containerName: String) {
        // Create instance
        delegate = NSPersistentCloudKitContainer(name: containerName)
        delegate.loadPersistentStores() {
            (storeDescription, error) in
            
            guard check(storeDescription: storeDescription, error: error) else {return}
            self.delegate.viewContext.automaticallyMergesChangesFromParent = true
        }
        
        // Fetch data and keep track of changes
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
    
    private let incorporateChanges = IncorporateChanges()
    
    private class IncorporateChanges: NSObject, NSFetchedResultsControllerDelegate {
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            print("*** CHANGES DETECTED. Reloading")
            if let provider = GTDataProvider.sharedInstance {provider.load()}
        }
    }
}

// MARK: - GameCenter
class GTGameCenter: ObservableObject {
    // MARK: Lifecycle: Get singleton instance
    private(set) static var sharedInstance: GTGameCenter? = nil
    
    fileprivate class func createSharedInstance(window: UIWindow) {
        if sharedInstance == nil {
            GTGameCenter.sharedInstance = GTGameCenter(window: window)
        }
     }
    
    fileprivate class func createSharedInstanceForPreview() {
        if sharedInstance == nil {
            GTGameCenter.sharedInstance = GTGameCenter(window: nil)
        }
     }

    // MARK: Usage: Is enabled, show GameCenter and report scores and achievements
    @Published private(set) var enabled: Bool = false
    
    /// Show GameCemter or login to GC
    public func show() {
        guard enabled else {return}
        
        if GKLocalPlayer.local.isAuthenticated {
            let gc = GKGameCenterViewController()
            gc.gameCenterDelegate = gcControllerDelegate
            window?.rootViewController?.present(gc, animated: true, completion:nil)
        } else if let uiController = uiController {
            window?.rootViewController?.present(uiController, animated: true, completion:nil)
        }
    }
    
    /// Report all current scores and achievements to GC
    public func report() {
        guard GKLocalPlayer.local.isAuthenticated else {return}
        
        GKScore.report(scores.map({
            (key: String, value: Score) -> GKScore in
            value.getGameCenterReporter(id: key)
        })) {
            (error) in
            guard check(error: error) else {return}
        }
        
        GKAchievement.report(achievements.map({
            (key: String, value: Achievement) -> GKAchievement in
            value.getGameCenterReporter(id: key)
        })) {
            (error) in
            guard check(error: error) else {return}
        }
    }

    // MARK: Internals
    private var uiController: UIViewController? = nil
    private let gcControllerDelegate = GCControllerDelegate()
    private let window: UIWindow?

    private init(window: UIWindow?) {
        self.window = window
        GKLocalPlayer.local.authenticateHandler = {
            (viewController, error) in
            
            if let viewController = viewController {
                self.uiController = viewController
            }
            
            // User authenticated
            if GKLocalPlayer.local.isAuthenticated {self.report()}
            self.enabled = (window != nil) && (self.uiController != nil || GKLocalPlayer.local.isAuthenticated)
        }
    }
    
    private class GCControllerDelegate: NSObject, GKGameCenterControllerDelegate {
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            
            gameCenterViewController.dismiss(animated: true, completion: nil)
        }
    }
}

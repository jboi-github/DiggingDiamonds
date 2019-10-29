//
//  SceneDelegate.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 16.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // TODO: Explain this. (have fun!)
        GameFrame.createSharedInstance(
            scene,
            consumablesConfig: ["CollectIt" : ("CollectIt", 7)],
            adUnitIdBanner: "ca-app-pub-3940256099942544/2934735716",
            adUnitIdRewarded: "ca-app-pub-3940256099942544/1712485313",
            adUnitIdInterstitial: "ca-app-pub-3940256099942544/4411468910") {
                MainView(
                    someScore: GameFrame.coreData.getScore("Some Score"),
                    someAchievement: GameFrame.coreData.getAchievement("Gold Medal"),
                    someNonConsumable: GameFrame.coreData.getNonConsumable("to be or not to be"),
                    someConsumable: GameFrame.coreData.getConsumable("CollectIt"))
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
    }
}


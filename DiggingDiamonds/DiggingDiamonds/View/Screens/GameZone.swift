//
//  GameZone.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 19.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import Foundation

struct GameZone: View {
    @ObservedObject var someScore: Score
    @ObservedObject var someAchievement: Achievement
    @ObservedObject var someNonConsumable: NonConsumable
    @ObservedObject var someConsumable: Consumable

    struct ScoreView: View {
        var id: String
        @ObservedObject var score: Score

        var body: some View {
            VStack {
                HStack {
                    Text(id).font(.title)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.score.earn(10)
                    }) {
                        Text("earn").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                    Button(action: {
                        self.score.startOver()
                    }) {
                        Text("start over").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                }
            }
        }
    }
    
    struct AchievementView: View {
        var id: String
        @ObservedObject var achievement: Achievement

        var body: some View {
            VStack {
                HStack {
                    Text(id).font(.title)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.achievement.achieved(self.achievement.current + 0.7)
                    }) {
                        Text("achieve 0.7").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                    Button(action: {
                        self.achievement.startOver()
                    }) {
                        Text("start over").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                }
            }
        }
    }
    
    struct NonConsumableView: View {
        var id: String
        @ObservedObject var nonConsumable: NonConsumable

        var body: some View {
            VStack {
                HStack {
                    Text(id).font(.title)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.nonConsumable.unlock()
                    }) {
                        Text("Open and unlock").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                }
            }
        }
    }
    
    struct ConsumableView: View {
        var id: String
        @ObservedObject var consumable: Consumable

        var body: some View {
            VStack {
                HStack {
                    Text(id).font(.title)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {
                        self.consumable.earn(10)
                    }) {
                        Text("earn").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                    Button(action: {
                        self.consumable.buy(5)
                    }) {
                        Text("buy").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                    Button(action: {
                        self.consumable.consume(7)
                    }) {
                        Text("consume").foregroundColor(.accentColor)
                    }.border(Color.accentColor)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("GameZone").font(.largeTitle).padding()
            ScoreView(id: "Some Score:", score: self.someScore)
            Divider()
            AchievementView(id: "Gold Medal(s):", achievement: self.someAchievement)
            Divider()
            NonConsumableView(id: "to be or not to be:", nonConsumable: self.someNonConsumable)
            Divider()
            ConsumableView(id: "Collect it:", consumable: self.someConsumable)
            Spacer()
        }
        .padding()
        .background(Color.gray)
        .foregroundColor(.white)
    }
}

struct GameZone_Previews: PreviewProvider {
    static var previews: some View {
        GTDataProvider.createSharedInstance(containerName: "DiggingDiamonds")
        return GameZone(
            someScore: GTDataProvider.sharedInstance!.getScore("Some Score"),
            someAchievement: GTDataProvider.sharedInstance!.getAchievement("Gold Medal"),
            someNonConsumable: GTDataProvider.sharedInstance!.getNonConsumable("to be or not to be"),
            someConsumable: GTDataProvider.sharedInstance!.getConsumable("Collect it")
        )
    }
}

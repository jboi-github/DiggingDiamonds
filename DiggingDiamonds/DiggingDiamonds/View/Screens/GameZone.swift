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
    @ObservedObject var someScore: GFScore
    @ObservedObject var someAchievement: GFAchievement
    @ObservedObject var someNonConsumable: GFNonConsumable
    @ObservedObject var someConsumable: GFConsumable
    var offeredConsumables: Binding<[GFConsumable]>

    struct ScoreView: View {
        var id: String
        @ObservedObject var score: GFScore

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
                        Text("earn")
                            .foregroundColor(.accentColor)
                            .padding()
                    }
                    .border(Color.accentColor)
                }
            }
        }
    }
    
    struct AchievementView: View {
        var id: String
        @ObservedObject var achievement: GFAchievement

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
                        Text("achieve 0.7")
                            .foregroundColor(.accentColor)
                            .padding()
                    }
                    .border(Color.accentColor)
                }
            }
        }
    }
    
    struct NonConsumableView: View {
        var id: String
        @ObservedObject var nonConsumable: GFNonConsumable

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
                        Text("Open and unlock")
                            .foregroundColor(.accentColor)
                            .padding()
                    }
                    .border(Color.accentColor)
                }
            }
        }
    }
    
    struct ConsumableView: View {
        var id: String
        @ObservedObject var consumable: GFConsumable

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
                        Text("earn").foregroundColor(.accentColor).padding()
                    }
                    .border(Color.accentColor)
                    Button(action: {
                        self.consumable.buy(5)
                    }) {
                        Text("buy").foregroundColor(.accentColor).padding()
                    }
                    .border(Color.accentColor)
                    Button(action: {
                        self.consumable.consume(7)
                    }) {
                        Text("consume").foregroundColor(.accentColor).padding()
                    }
                    .disabled(self.consumable.available < 7)
                    .border(Color.accentColor)
                }
            }
        }
    }
    
    @State var inLevel: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("GameZone").font(.largeTitle)
            Divider()
            ScoreView(id: "Some Score:", score: self.someScore)
            AchievementView(id: "Gold Medal(s):", achievement: self.someAchievement)
            NonConsumableView(id: "to be or not to be:", nonConsumable: self.someNonConsumable)
            ConsumableView(id: "Collect it:", consumable: self.someConsumable)
            Divider()
            HStack {
                Button(action: {
                    self.inLevel.toggle()
                    if self.inLevel {
                        GameFrame.instance.enterLevel()
                    } else {
                        GameFrame.instance.leaveLevel(requestReview: true, showInterstitial: true)
                    }
                }) {
                    Text(inLevel ? "Leave Level" : "Enter Level")
                        .foregroundColor(.accentColor)
                        .padding()
                }
                .border(Color.accentColor)
                Button(action: {
                    self.offeredConsumables.wrappedValue = GameFrame.inApp.getConsumables(ids: ["CollectIt"])
                }) {
                    Text("Good Run").foregroundColor(.accentColor).padding()
                }
                .disabled(self.someConsumable.available >= 7)
                .border(Color.accentColor)
            }
            Spacer()
        }
        .padding()
        .background(Color.gray)
        .foregroundColor(.white)
    }
}

struct GameZone_Previews: PreviewProvider {
    @State static var offeredConsumables = [GFConsumable]()
    
    static var previews: some View {
        GameFrame.createSharedInstanceForPreview(
            consumablesConfig: ["CollectIt" : ("CollectIt", 7)],
            adUnitIdBanner: "ca-app-pub-3940256099942544/2934735716",
            adUnitIdRewarded: "ca-app-pub-3940256099942544/1712485313",
            adUnitIdInterstitial: "ca-app-pub-3940256099942544/4411468910")
        return GameZone(
            someScore: GameFrame.coreData.getScore("Some Score"),
            someAchievement: GameFrame.coreData.getAchievement("Gold Medal"),
            someNonConsumable: GameFrame.coreData.getNonConsumable("to be or not to be"),
            someConsumable: GameFrame.coreData.getConsumable("CollectIt"),
            offeredConsumables: $offeredConsumables)
    }
}

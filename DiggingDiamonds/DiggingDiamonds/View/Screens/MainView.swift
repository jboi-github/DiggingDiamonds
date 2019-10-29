//
//  MainView.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 17.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI
import StoreKit

struct MainView: View {
    @ObservedObject var someScore: GFScore
    @ObservedObject var someAchievement: GFAchievement
    @ObservedObject var someNonConsumable: GFNonConsumable
    @ObservedObject var someConsumable: GFConsumable
    @ObservedObject var gtAdMob = GameFrame.adMob

    private struct NavigationArea: View {
        @ObservedObject var someConsumable: GFConsumable
        @ObservedObject var gtGameCenter = GameFrame.gameCenter
        @ObservedObject var gtAdMob = GameFrame.adMob

        var body: some View {
            VStack {
                Divider()
                HStack {
                    ImageNavigationLink(systemName: "cart", destination: InAppStoreView())
                    ImageButton(systemName: "gear", action: getUrlAction(UIApplication.openSettingsURLString))
                    ImageButton(systemName: "rosette") {
                        self.gtGameCenter.show()
                    }
                    .disabled(!gtGameCenter.enabled)
                    ImageButton(systemName: "link", action: getUrlAction("http://www.apple.com"))
                }
                Divider()
                HStack {
                    ImageButton(systemName: "hand.thumbsup", action: getUrlAction("https://itunes.apple.com/app/idXXXXXXXXXX?action=write-review"))
                    ImageButton(systemName: "film") {
                        self.gtAdMob.showReward(consumable: self.someConsumable, quantity: 14)
                    }
                    .disabled(!self.gtAdMob.rewardAvailable)
                    ImageButton(systemName: "recordingtape") {
                        print("Button 4")
                    }
                }
                Divider()
            }
        }
    }
    
    private struct InformationArea: View {
        @ObservedObject var someScore: GFScore
        @ObservedObject var someAchievement: GFAchievement
        @ObservedObject var someNonConsumable: GFNonConsumable
        @ObservedObject var someConsumable: GFConsumable

        var body: some View {
            VStack {
                Divider()
                HStack {
                    Text("Some Score: ").font(.caption)
                    Text("\(someScore.current) / \(someScore.highest)").bold()
                    Spacer()
                    Text("Gold Medal: ").font(.caption)
                    Text("\(someAchievement.current.format(".1")) / \(someAchievement.highest.format(".1")) /  \(someAchievement.timesAchieved)").bold()
                }
                HStack {
                    Text("to be or not to be: ").font(.caption)
                    Text("\(someNonConsumable.isOpened ? "open":"closed")").bold()
                    Spacer()
                    Text("Collect it: ").font(.caption)
                    Text("\(someConsumable.available)").bold()
                }
                Divider()
            }.padding()
        }
    }
    
    @State var offeredConsumables = [GFConsumable]()
    
    var body: some View {
        VStack {
            ZStack {
                GameZone(
                    someScore: someScore,
                    someAchievement: someAchievement,
                    someNonConsumable: someNonConsumable,
                    someConsumable: someConsumable,
                    offeredConsumables: $offeredConsumables)
                VStack {
                    NavigationArea(someConsumable: someConsumable)
                    Spacer()
                    InformationArea(
                        someScore: someScore,
                        someAchievement: someAchievement,
                        someNonConsumable: someNonConsumable,
                        someConsumable: someConsumable)
                }
            }
            .blur(radius: offeredConsumables.isEmpty ? 0.0 : 5.0)
            .overlay(InAppOfferView(offeredConsumables: $offeredConsumables))
            ZStack {
                GFBannerView()
                Text("Thank you for playing The Game")
                    .opacity(gtAdMob.bannerAvailable ? 0.0 : 1.0)
            }
            .frame(width: gtAdMob.bannerWidth, height: gtAdMob.bannerHeight)
            .background(Color.blue)
        }
        .statusBar(hidden: true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        GameFrame.createSharedInstanceForPreview(
            consumablesConfig: ["CollectIt" : ("CollectIt", 7)],
            adUnitIdBanner: "ca-app-pub-3940256099942544/2934735716",
            adUnitIdRewarded: "ca-app-pub-3940256099942544/1712485313",
            adUnitIdInterstitial: "ca-app-pub-3940256099942544/4411468910")
        return MainView(
            someScore: GameFrame.coreData.getScore("Some Score"),
            someAchievement: GameFrame.coreData.getAchievement("Gold Medal"),
            someNonConsumable: GameFrame.coreData.getNonConsumable("to be or not to be"),
            someConsumable: GameFrame.coreData.getConsumable("CollectIt"))
    }
}

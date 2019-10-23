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
    @ObservedObject var someScore: Score
    @ObservedObject var someAchievement: Achievement
    @ObservedObject var someNonConsumable: NonConsumable
    @ObservedObject var someConsumable: Consumable

    private struct NavigationArea: View {
        @ObservedObject var gtGameCenter = GTGameCenter.sharedInstance!

        var body: some View {
            VStack {
                Divider()
                HStack {
                    ImageNavigationLink(systemName: "cart", destination: InAppStoreView())
                    ImageNavigationLink(systemName: "gear", destination: SettingsView())
                    ImageButton(systemName: "rosette") {
                        self.gtGameCenter.show()
                    }
                    .disabled(!gtGameCenter.enabled)
                    ImageButton(systemName: "link", action: getUrlAction("http://www.apple.com"))
                }
                Divider()
                HStack {
                    ImageNavigationLink(systemName: "cart.badge.plus", destination: InAppOfferView())
                    ImageButton(systemName: "hand.thumbsup") {
                        SKStoreReviewController.requestReview()
                    }
                    ImageButton(systemName: "film") {
                        print("Button 3")
                    }
                    ImageButton(systemName: "recordingtape") {
                        print("Button 4")
                    }
                }
                Divider()
            }
        }
    }
    
    private struct InformationArea: View {
        @ObservedObject var someScore: Score
        @ObservedObject var someAchievement: Achievement
        @ObservedObject var someNonConsumable: NonConsumable
        @ObservedObject var someConsumable: Consumable

        var body: some View {
            VStack {
                Divider()
                HStack {
                    Text("Some Score: ").font(.headline)
                    Spacer()
                    Text("Current: ").font(.caption)
                    Text("\(someScore.current)").bold()
                    Spacer()
                    Text("Highest: ").font(.caption)
                    Text("\(someScore.highest)").bold()
                }
                HStack {
                    Text("Gold Medal: ").font(.headline)
                    Spacer()
                    Text("Current: ").font(.caption)
                    Text("\(someAchievement.current.format(".1"))").bold()
                    Spacer()
                    Text("Highest: ").font(.caption)
                    Text("\(someAchievement.highest.format(".1"))").bold()
                    Spacer()
                    Text("times achieved: ").font(.caption)
                    Text("\(someAchievement.timesAchieved)").bold()
                }
                HStack {
                    Text("to be or not to be: ").font(.headline)
                    Spacer()
                    Text("isOpen: ").font(.caption)
                    Text("\(someNonConsumable.isOpened ? "YES":"NO")").bold()
                }
                HStack {
                    Text("Collect it: ").font(.headline)
                    Spacer()
                    Text("avaliable: ").font(.caption)
                    Text("\(someConsumable.available)").bold()
                }
                Divider()
            }.padding()
        }
    }

    var body: some View {
        return VStack {
            NavigationView {
                ZStack {
                    GameZone(
                        someScore: someScore,
                        someAchievement: someAchievement,
                        someNonConsumable: someNonConsumable,
                        someConsumable: someConsumable)
                    VStack {
                        NavigationArea()
                        Spacer()
                        InformationArea(
                            someScore: someScore,
                            someAchievement: someAchievement,
                            someNonConsumable: someNonConsumable,
                            someConsumable: someConsumable)
                    }
                }
                .navigationBarTitle(Text("Main Screen"), displayMode: .inline)
            }
            Text("Banner")
                .frame(width: 240, height: 50, alignment: .center)
                .background(Color.blue)
        }
        .statusBar(hidden: true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        GTDataProvider.createSharedInstanceForPreview(containerName: "DiggingDiamonds")
        return MainView(
            someScore: GTDataProvider.sharedInstance!.getScore("Some Score"),
            someAchievement: GTDataProvider.sharedInstance!.getAchievement("Gold Medal"),
            someNonConsumable: GTDataProvider.sharedInstance!.getNonConsumable("to be or not to be"),
            someConsumable: GTDataProvider.sharedInstance!.getConsumable("Collect it")
        )
    }
}

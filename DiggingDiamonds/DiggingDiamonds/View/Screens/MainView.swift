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
    private var navigationArea: some View {
        VStack {
            Divider()
            HStack {
                ImageNavigationLink(systemName: "cart", destination: InAppStoreView())
                ImageNavigationLink(systemName: "gear", destination: SettingsView())
                ImageButton(systemName: "rosette") {
                    print("Button 1")
                }
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
            Spacer()
        }
    }
    
    private var gameZone: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("GameZone").font(.largeTitle)
                Spacer()
            }
            Spacer()
        }
        .background(Color.gray)
        .foregroundColor(.white)
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    gameZone
                    navigationArea
                }
                Text("Banner")
                    .frame(width: 240, height: 50, alignment: .center)
                    .background(Color.blue)
            }
            .navigationBarTitle(Text("Main Screen"), displayMode: .inline)
        }
        .statusBar(hidden: true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

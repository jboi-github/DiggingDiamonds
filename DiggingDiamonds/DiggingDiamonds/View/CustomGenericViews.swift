//
//  CustomViews.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 19.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

fileprivate struct ImageButtonBody : View {
    var systemName: String
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: systemName)
            Spacer()
        }
    }
}

struct ImageButton : View {
    var systemName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {ImageButtonBody(systemName: systemName)}
    }
}

struct ImageNavigationLink<Destination : View> : View {
    var systemName: String
    var destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            ImageButtonBody(systemName: systemName)
        }
    }
}

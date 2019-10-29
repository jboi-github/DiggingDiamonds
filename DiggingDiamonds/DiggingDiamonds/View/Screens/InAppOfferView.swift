//
//  InAppOfferView.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 17.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import SwiftUI

struct InAppOfferView: View {
    var offeredConsumables: Binding<[GFConsumable]>
    
    private struct ProductRow: View {
        var product: GFConsumable
        
        var body: some View {
            let p = product.products.first!.value
            
            return Button(action: {
                GameFrame.inApp.buy(product: p, quantity: 1)
            }) {
                Text("\(p.localizedTitle)").font(.title)
                Text("\(p.localizedDescription)").font(.subheadline)
                Text("\(p.localizedPrice)")
            }
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if self.offeredConsumables.wrappedValue.isEmpty {
                EmptyView()
            } else {
                ZStack {
                    Color.black.opacity(0.25)
                    VStack {
                        ProductRow(product: self.offeredConsumables.wrappedValue[0])
                        Button(action: {
                            self.offeredConsumables.wrappedValue.removeAll()
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Dismiss").foregroundColor(.accentColor).padding()
                        }
                        .border(Color.accentColor)
                    }
                    .padding()
                    .background(Color.gray)
                    .opacity(0.75)
                }
            }
        }
    }
}

struct InAppOfferView_Previews: PreviewProvider {
    @State static var offeredConsumables = [GameFrame.coreData.getConsumable("CollectIt"), GameFrame.coreData.getConsumable("CollectIt")]
    
    static var previews: some View {
        InAppOfferView(offeredConsumables: $offeredConsumables)
    }
}

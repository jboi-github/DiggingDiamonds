//
//  ControllerActions.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 18.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import UIKit

func getUrlAction(_ url: String) -> () -> Void {
    if let url = URL(string: url) {
        return {UIApplication.shared.open(url)}
    } else {
        return {} // Do nothing
    }
}

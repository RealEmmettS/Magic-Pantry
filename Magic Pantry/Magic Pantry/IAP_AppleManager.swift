//
//  IAP_AppleManager.swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 3/3/21.
//  Copyright © 2021 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

class IAP_AppleManager{
    
    var premium: SKProduct?
    
    func fetchProducts(view:SKProductsRequestDelegate){
        //dev.emmetts.MagicPantry.premiumpurchase
        let request = SKProductsRequest(productIdentifiers: ["dev.emmetts.MagicPantry.premiumpurchase"])
        request.delegate = view
        request.start()
    }
    
}

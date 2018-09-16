//
//  Grocery Store.swift
//  Grocery List Pro
//
//  Created by Emmett Shaughnessy on 7/13/18.
//  Copyright © 2018 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import FirebaseDatabase

var GlobalsaddedByUser = ""

struct GroceryStore{
    
    let skey:String!
    let scontent:String!
    let itemRef:DatabaseReference?
    
    init (scontent:String, saddedByUser:String, skey:String = "") {
        self.skey = skey
        self.scontent = scontent
        GlobalsaddedByUser = saddedByUser
        self.itemRef = nil
    }
    
    init (snapshot:DataSnapshot) {
        skey = snapshot.key
        itemRef = snapshot.ref
        
        
        if let dict = snapshot.value as? NSDictionary, let StoreContent = dict["scontent"] as? String {
            scontent = StoreContent
        } else {
            scontent = ""
        }
        
        
        if let dict = snapshot.value as? NSDictionary, let itemUser = dict["saddedByUser"] as? String {
            GlobalsaddedByUser = itemUser
        } else {
            GlobalsaddedByUser = ""
        }
        
    }
    
    func toAnyObject() -> Any {
        return ["scontent":scontent, "saddedByUser":GlobalsaddedByUser]
    }
    
    
}

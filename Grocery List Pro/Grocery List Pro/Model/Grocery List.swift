//
//  Grocery List.swift
//  Grocery List Pro
//
//  Created by Emmett Shaughnessy on 7/12/18.
//  Copyright © 2018 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct GroceryItem{
    
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:DatabaseReference?
    
    init (content:String, addedByUser:String, key:String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    init (snapshot:DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        
        if let dict = snapshot.value as? NSDictionary, let itemContent = dict["content"] as? String {
            content = itemContent
        } else {
            content = ""
        }
        
        
        if let dict = snapshot.value as? NSDictionary, let itemUser = dict["addedByUser"] as? String {
            addedByUser = itemUser
        } else {
            addedByUser = ""
        }

    }
    
    func toAnyObject() -> Any {
        return ["content":content, "addedByUser":addedByUser]
    }
    
    
    
}

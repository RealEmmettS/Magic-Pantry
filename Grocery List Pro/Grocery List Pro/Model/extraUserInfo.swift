//
//  extraUserInfo.swift
//  Grocery List Pro
//
//  Created by Emmett Shaughnessy on 7/13/18.
//  Copyright © 2018 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct extraUserInfo{
    var currentUsersEmail:String!
    
    init(currentUsersEmail:String) {
        self.currentUsersEmail = currentUsersEmail
        
        
    }
}

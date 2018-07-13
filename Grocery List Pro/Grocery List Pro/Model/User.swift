//
//  User.swift
//  Grocery List Pro
//
//  Created by Emmett Shaughnessy on 7/12/18.
//  Copyright © 2018 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


struct User{
    var uid:String
    let email:String
    
    var user = Auth.auth().currentUser;
    
    init(userdata:User){
        uid = userdata.uid
        
        if let mail = user?.providerData.first?.email{
            email = mail
        } else {
            email = ""
        }
    }
    
    
    init (uid:String, email:String){
        self.uid = uid
        self.email = email
        
    }
}

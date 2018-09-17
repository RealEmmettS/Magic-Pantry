//
//  UserSettings.swift
//  Grocery List Pro
//
//  Created by Emmett Shaughnessy on 9/15/18.
//  Copyright © 2018 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserSettings: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid == nil{
            okButton.isHidden = false
            okButton.isEnabled = true
            errorLabel.isHidden = false
            backButton.isHidden = true
            backButton.isEnabled = false
            
            emailLabel.isHidden = true
            passwordLabel.isHidden = true
            
            emailTitle.isHidden = true
            passwordTitle.isHidden = true
            
            passwordChnage.isHidden = true
            passwordChnage.isEnabled = false
        } else {
            okButton.isHidden = true
            okButton.isEnabled = false
            errorLabel.isHidden = true
            backButton.isHidden = false
            backButton.isEnabled = true
            
            emailLabel.isHidden = false
            passwordLabel.isHidden = false
            emailTitle.isHidden = false
            passwordTitle.isHidden = false
            
            passwordChnage.isHidden = false
            passwordChnage.isEnabled = true
        }
        
        if Auth.auth().currentUser?.uid != nil {
            emailLabel.text = ("\(Auth.auth().currentUser!.email!)")
            passwordLabel.text = (theUserPassword)
        } else {
            emailLabel.text = ("Unavailable")
            passwordLabel.text = ("Unavailable")
        }
        
    }
    
    
    //Setup
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordChnage: UIButton!
    var newEmail = ""
    
    
    
    
    
    
    @IBAction func changePassword(_ sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: currentUsersEmail.currentUsersEmail)
    }
    
    
    
    

}

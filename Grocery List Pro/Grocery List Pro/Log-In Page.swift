//
//  Log-In Page.swift
//  Grocery List Pro
//
//  Created by Emmett Shaughnessy on 9/16/18.
//  Copyright © 2018 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

var theUserEmail = ""
var theUserPassword = ""
var validationID = ""

class Log_In_Page: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        continueToList.isEnabled = false
        if Auth.auth().currentUser?.uid != nil{
            print("Working...")
            signedInAlready()
            print("Done")
        } else {
            notSignedInAlready()
            print("No one signed in")
        }
    }
    //setup
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var aLabel: UILabel!
    @IBOutlet weak var aButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var continueToList: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    func signedInAlready(){
        emailField.isHidden = true
        passwordField.isHidden = true
        passwordField.isEnabled = false
        emailField.isEnabled = false
        
        signInButton.isHidden = true
        signUpButton.isHidden = true
        signUpButton.isEnabled = false
        signInButton.isEnabled = false
        
        aLabel.isHidden = false
        aButton.isHidden = false
        aButton.isEnabled = true
        
        continueToList.isEnabled = false
        continueToList.isHidden = true
        
        signOutButton.isEnabled = true
        signOutButton.isHidden = false
    }
    func notSignedInAlready(){
        emailField.isHidden = false
        passwordField.isHidden = false
        passwordField.isEnabled = true
        emailField.isEnabled = true
        
        signInButton.isHidden = false
        signUpButton.isHidden = false
        signUpButton.isEnabled = true
        signInButton.isEnabled = true
        
        aLabel.isHidden = true
        aButton.isHidden = true
        aButton.isEnabled = false
        
        continueToList.isEnabled = false
        continueToList.isHidden = false
        
        signOutButton.isEnabled = false
        signOutButton.isHidden = true
    }
    
    
    @IBAction func signOutClicked(_ sender: Any) {
        
        currentUsersEmail.currentUsersEmail = ""
        validationID = ""
        notSignedInAlready()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            signOutNotificationERROR()
        }
    }
    
    //Sign Out Error
    func signOutNotificationERROR() {
        let ErrorAlert = UIAlertController(title: "Error", message: "Sign Out Failed.\nPlease Try Again", preferredStyle: .alert)
        
        ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ErrorAlert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    @IBAction func SignIn(_ sender: Any) {
        
        if emailField.text == "" || passwordField.text == ""{
            let ErrorAlert = UIAlertController(title: "Error", message: "Field is empty", preferredStyle: .alert)
            
            ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(ErrorAlert, animated: true, completion: nil)
            print("hello")
        } else {
        print("hello1234")
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if Error.self != nil{
                print("\n\n\(error?.localizedDescription)\n\n")
                print("It worked. Moving on...")
            } else {
                print("nope")
            }
        
        }
        currentUsersEmail.currentUsersEmail = emailField.text!
            
            if Auth.auth().currentUser?.uid != nil{
                print("Signing In...")
            } else {
                notSignedInAlready()
                print("NO WORK. TRY AGAIN")
            }
        
        theUserEmail = emailField.text!
        theUserPassword = passwordField.text!
        continueToList.isEnabled = true
//            if Auth.auth().currentUser?.uid == nil{
//                continueToList.isEnabled = false
//                ERROR()
//            } else {
//                continueToList.isEnabled = true
//            }
    }
    }
    
    
    
    
    
    @IBAction func SignUp(_ sender: Any) {
        
        if emailField.text == nil || passwordField.text == nil{
            let ErrorAlert = UIAlertController(title: "Error", message: "Field is empty", preferredStyle: .alert)
            
            ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(ErrorAlert, animated: true, completion: nil)
            
        } else {
            
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (authResult, error) in
            
            if Error.self != nil {
                print("ok. nu wurk. plz trie agen okey?")
            } else {
                UserDefaults.standard.setValue(user?.uid, forKey: "uid")
                print("Login went well. Clear to proceed.")
            }
        }
        currentUsersEmail.currentUsersEmail = emailField.text!
        
        theUserEmail = emailField.text!
        theUserPassword = passwordField.text!
        continueToList.isEnabled = true
            
        
        
    }
}
    
    
//    func ERROR() {
//        let ErrorAlert = UIAlertController(title: "Error", message: "Sign In/ Sign Up failed.\nTry Again", preferredStyle: .alert)
//
//        ErrorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//        self.present(ErrorAlert, animated: true, completion: nil)
//    }
 
}

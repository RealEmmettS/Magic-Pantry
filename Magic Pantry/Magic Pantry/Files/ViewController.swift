//
//  ViewController.swift
//  CongressAppChallenge
//
//  Created by Emmett Shaughnessy on 10/16/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth
var NewUserCreation = true

class ViewController: UIViewController, FUIAuthDelegate, AuthUIDelegate {

    
    //MARK: viewDidLoad and Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UID.isHidden = true
        
        UName = ""
        UserID = ""
        //Sets the name label to include the current user's name
        Name.text = "Name: None"
        UID.text = "User ID: None"
        
        if Auth.auth().currentUser?.email != nil{
            UserIsLoggedIn = true
            Name.text = "Hey User!"
        } else {
            UserIsLoggedIn = false
            print("Please Log In to What's Due")
        }
        
        //Checking to see if the user is logged in. By the way, the if statement defaults to true if we don't fill out the rest (if UserLoggedIn = true...)
        if UserIsLoggedIn! {
            //Running the above code again to update our on-screen data
            UName = (Auth.auth().currentUser?.email)!
            UserID = String(Auth.auth().currentUser!.uid)
            
            Name.text = "Email: \(UName!)"
            UID.text = "User ID: \(UserID!)"
            
            
            print("Logged In. Let's go on...")
            
        }else if UserIsLoggedIn == false{
            
            print("Continue with our code below")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.email != nil{
            UserIsLoggedIn = true
            Name.text = "Hey"
        } else {
            print("Nope")
        }
        
        //Checking to see if the user is logged in. By the way, the if statement defaults to true if we don't fill out the rest (if UserLoggedIn = true...)
        if UserIsLoggedIn! {
            //Running the above code again to update our on-screen data
            UName = (Auth.auth().currentUser?.email)!
            UserID = String(Auth.auth().currentUser!.uid)
            
            Name.text = "Email: \(UName!)"
            UID.text = "User ID: \(UserID!)"
            
            
            print("Logged In. Let's go on...")
            
        }else if UserIsLoggedIn == false{
            
            print("Continue with our code below")
        }
    }
    
    
    
    
    
    
    
    
    
    
    

    //With the next two lines (@IBOutlet) we are simply connecting our User Interface elements to our code. This does nothing in particular besides let us access UI elements throught the code later on
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var UID: UILabel!
    
    //Each @IBAction is a method which is called when you press the corresponding buttons
    //MARK: Button Actions
    @IBAction func NewUser(_ sender: Any) {
        //Shows the current user the Sign In page
        present(SetupAuthUI(), animated: true, completion: nil)
        refreshVariables()
        func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
            //Checks if an error occured. If there was an error, the code below runs
          print("Oh No")
        }
    }
    
    @IBAction func GoToLists(_ sender: Any) {
        if isSignedIn() == true {
            performSegue(withIdentifier: "GoToLists", sender: self)
        } else {
            throwNotSignedInError()
        }
    }

    @IBAction func SignOutUser(_ sender: Any) {
        //Resetting AuthUI and its properties
        let authUI = FUIAuth.defaultAuthUI()
        authUI!.delegate = self
        let providers: [FUIAuthProvider] = [
          //3FUIGoogleAuth(),
          FUIEmailAuth(),
          /*FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),*/
        ]
        authUI!.providers = providers

        //Signing out of everything...
        do {
            try authUI!.signOut()
            ShowSignedOut()
        } catch {
            print("Uh-Oh")
        }
    }
    
    @IBAction func RefreshView(_ sender: Any) {
        refreshVariables()
    }
    
    
    
    
    
    
    //MARK: Functions
    func SetupAuthUI() -> UINavigationController{
        let authUI = FUIAuth.defaultAuthUI()
           // You need to adopt a FUIAuthDelegate protocol to receive callback
           authUI!.delegate = self
           
           let providers: [FUIAuthProvider] = [
             //FUIGoogleAuth(),
             FUIEmailAuth(),
             /*FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),*/
           ]
           authUI!.providers = providers
           
           //Getting the Auth View Controller
           let authViewController = authUI!.authViewController()
        return authViewController
    }
    
    
    
    func refreshVariables(){
        if Auth.auth().currentUser?.email != nil || Auth.auth().currentUser?.phoneNumber != nil{
            UName = Auth.auth().currentUser!.email!
            UserID = String(Auth.auth().currentUser!.uid)
            //Sets the name label to include the current user's name
            Name.text = "Email: \(UName!)"
            UID.text = "User ID: \(UserID!)"
        } else {
            print("User not logged in")
            UName = ""
            UserID = ""
            //Sets the name label to include the current user's name
            Name.text = "Email: None"
            UID.text = "User ID: None"
        }
    }
    
    func ShowSignedOut(){
        let alertController = UIAlertController(title: "Signed Out", message:
               "You have successfully signed out", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.refreshVariables()
        }))

           self.present(alertController, animated: true, completion: nil)
    }
    
    func isSignedIn() -> Bool{
        let email = Auth.auth().currentUser?.email
        if email != nil {
            return true
        } else {
            return false
        }
    }
    
    func throwNotSignedInError(){
        let alertController = UIAlertController(title: "Not Signed In", message:
               "You have not signed in yet. Please sign in to proceed to lists.", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //Shows the current user the Sign In page
            self.present(self.SetupAuthUI(), animated: true, completion: nil)
            self.refreshVariables()
            func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
              print("Oh No")
            }
        }))

           self.present(alertController, animated: true, completion: nil)
    }
    

    
}


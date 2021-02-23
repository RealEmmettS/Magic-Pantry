//
//  ViewController.swift
//  CongressAppChallenge
//
//  Created by Emmett Shaughnessy on 10/16/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.




//███╗░░░███╗░█████╗░░██████╗░██╗░█████╗░  ██████╗░░█████╗░███╗░░██╗████████╗██████╗░██╗░░░██╗
//████╗░████║██╔══██╗██╔════╝░██║██╔══██╗  ██╔══██╗██╔══██╗████╗░██║╚══██╔══╝██╔══██╗╚██╗░██╔╝
//██╔████╔██║███████║██║░░██╗░██║██║░░╚═╝  ██████╔╝███████║██╔██╗██║░░░██║░░░██████╔╝░╚████╔╝░
//██║╚██╔╝██║██╔══██║██║░░╚██╗██║██║░░██╗  ██╔═══╝░██╔══██║██║╚████║░░░██║░░░██╔══██╗░░╚██╔╝░░
//██║░╚═╝░██║██║░░██║╚██████╔╝██║╚█████╔╝  ██║░░░░░██║░░██║██║░╚███║░░░██║░░░██║░░██║░░░██║░░░
//╚═╝░░░░░╚═╝╚═╝░░╚═╝░╚═════╝░╚═╝░╚════╝░  ╚═╝░░░░░╚═╝░░╚═╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░╚═╝░░░╚═╝░░░



import UIKit
import Firebase
import FirebaseUI
import FirebaseAuth
var NewUserCreation = true

class ViewController: UIViewController, FUIAuthDelegate, AuthUIDelegate {

    
    
    
    //With the next two lines (@IBOutlet) we are simply connecting our User Interface elements to our code. This does nothing in particular besides let us access UI elements throught the code later on
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    
    //MARK: viewDidLoad and Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UID.isHidden = true
        
        //overrideUserInterfaceStyle = .light

        
        UName = ""
        UserID = ""
        //Sets the name label to include the current user's name
        Name.text = "Please sign-in or refresh"
        //UID.text = "User ID: None"
        
        if Auth.auth().currentUser?.email != nil{
            UserIsLoggedIn = true
        } else {
            UserIsLoggedIn = false
        }
        
        
        if UserIsLoggedIn! {
            //Running the above code again to update our on-screen data
            UName = (Auth.auth().currentUser?.email)!
            UserID = String(Auth.auth().currentUser!.uid)
            
            Name.text = "Email: \(UName!)"
            signInButton.setTitle("Sign-Out", for: .normal)
            //UID.text = "User ID: \(UserID!)"
            
            
            print("Logged In. Let's go on...")
            
        }else if UserIsLoggedIn == false{
            
            signInButton.setTitle("Sign-In", for: .normal)
            print("Continue with our code below")
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.email != nil{
            UserIsLoggedIn = true
            Name.text = "Email: \(Auth.auth().currentUser?.email)"
        } else {
            UserIsLoggedIn = false
            print("Nope")
        }
        
        if UserIsLoggedIn! {
            //Running the above code again to update our on-screen data
            UName = (Auth.auth().currentUser?.email)!
            UserID = String(Auth.auth().currentUser!.uid)
            
            
            
            Name.text = "Email: \(UName!)"
            //UID.text = "User ID: \(UserID!)"
            
            
            print("Logged In. Let's go on...")
            
        }else if UserIsLoggedIn == false{
            
            print("Continue with our code below")
        }
    }
    
    
    
//
//             (__)     (__)
//             (oo)     (oo)
//      /-------\/       \/-------\
//     / |     ||  \__/  ||      | \
//    *  ||----||  |  |  ||-----||  *
//       ~~    ~~  |__|  ~~     ~~
//
//             cowoperation
    
    
    
    //Code Starts Here
    
    
    @objc func callback() { //used after user signs in
        print("waited..checking user authentication")
        updateNewUser()
    }
    
    
    //MARK: Button Actions
    @IBAction func SignInSignOut(_ sender: Any) {
        if Auth.auth().currentUser?.email != nil {
            signOutWithFirebase()
        } else if Auth.auth().currentUser?.email == nil{
            signInWithFirebase()
        }
    }
    
    func updateNewUser(){
        refreshVariables()
    }
    
    @IBAction func GoToLists(_ sender: Any) {
        if isSignedIn() == true {
            performSegue(withIdentifier: "GoToLists", sender: self)
        } else {
            throwNotSignedInError()
        }
    }

    
    @IBAction func RefreshView(_ sender: Any) {
        refreshVariables()
    }
    
    
    
    
    func signInWithFirebase(){
        //Shows the current user the Sign In page
        present(SetupAuthUI(), animated: true, completion: refreshVariables)
        refreshVariables()
        
        if presentedViewController!.isBeingDismissed{
            print("Dismissing...")
            refreshVariables()
            perform(#selector(callback), with: nil, afterDelay: 3.0)
        }
        func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
          print("Oh No")
            refreshVariables()
        }
        
        func authUI(_ authUI: FUIAuth, didSignInWith user: User?) {
            refreshVariables()
        }
        
        perform(#selector(callback), with: nil, afterDelay: 3.0) //uses the objective-c function "callback" declared above
    }
    
    func signOutWithFirebase(){
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
    
    
    
    
    //App Icon Change - Temporarily Removed
//    let appIconService = AppIconService()
//    @IBAction func NewIcon(_ sender: Any) {
//        print("Updating...")
//        //appIconService.changeAppIcon(to: .MainIcon)
//        //UIApplication.shared.setAlternateIconName("MainIcon")
//        changeIcon(name: nil)
//        print("Icon Updated")
//    }
//    @IBAction func OldIcon(_ sender: Any) {
//        print("Updating...")
//        //appIconService.changeAppIcon(to: .OrignalIcon)
//        //UIApplication.shared.setAlternateIconName("OrignalIcon")
//        changeIcon(name: "original")
//        print("Icon Updated")
//    }
    
    
    

//                 (__)
//                 (-o)
//           /------\/
//          /|     ||
//         * ||----||

    
    
    

//    █▀▀ █ █▀█ █▀▀ █▄▄ ▄▀█ █▀ █▀▀   █░░ █▀█ █▀▀ █ █▄░█
//    █▀░ █ █▀▄ ██▄ █▄█ █▀█ ▄█ ██▄   █▄▄ █▄█ █▄█ █ █░▀█
    
    
    //MARK: Firebase UI
    func SetupAuthUI() -> UINavigationController{
        
        let authUI = FUIAuth.defaultAuthUI()
           // You need to adopt a FUIAuthDelegate protocol to receive callback
           authUI!.delegate = self
           
           let providers: [FUIAuthProvider] = [
             FUIGoogleAuth(),
             FUIEmailAuth(),
             FUIOAuth.appleAuthProvider()
             //FUIGitHubAuth(),
             /*FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),*/
           ]
           authUI!.providers = providers
           
           //Getting the Auth View Controller
           let authViewController = authUI!.authViewController()
        return authViewController
    }
    
    
//    █▀▀ █ █▀█ █▀▀ █▄▄ ▄▀█ █▀ █▀▀   █░░ █▀█ █▀▀ █ █▄░█
//    █▀░ █ █▀▄ ██▄ █▄█ █▀█ ▄█ ██▄   █▄▄ █▄█ █▄█ █ █░▀█

    
    
    
//                            (__)
//                            (oo)
//       /---------------------\/
//     /  |   |   |   |   |   ||
//    *   ||--||--||--||--||--||
//        ^^  ^^  ^^  ^^  ^^  ^^
//            Cowterpillar
    
    
    
    
    
    //MARK: Functions
    func refreshVariables(){
        if Auth.auth().currentUser?.email != nil || Auth.auth().currentUser?.phoneNumber != nil{
            UName = Auth.auth().currentUser!.email!
            UserID = String(Auth.auth().currentUser!.uid)
            //Sets the name label to include the current user's name
            Name.text = "Email: \(UName!)"
            //UID.text = "User ID: \(UserID!)"
            signInButton.setTitle("Sign-Out", for: .normal)
        } else {
            print("User not logged in")
            UName = ""
            UserID = ""
            //Sets the name label to include the current user's name
            Name.text = "Please sign-in or refresh"
            //UID.text = "User ID: None"
            signInButton.setTitle("Sign-In", for: .normal)
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
    
    
    
    
    
    
    
    
//                         (__)
//                         (oo)
//         /--------------- \/
//       / ( !S M T W T F! )
//     /  (  +-+-+-+-+-+-+  )
//    *   (  +-+-+-+-+-+-+  )
//         ( +-+-+-+-+-+-+ )
//          (+-+-+-+-+-+-+)
//           ||        ||
//           ||        ||
//           ^^        ^^
//           "COWLENDAR"
    
    
    
    
    

//    ███████╗██╗░░██╗██████╗░███████╗██████╗░██╗███╗░░░███╗███████╗███╗░░██╗████████╗░█████╗░██╗░░░░░
//    ██╔════╝╚██╗██╔╝██╔══██╗██╔════╝██╔══██╗██║████╗░████║██╔════╝████╗░██║╚══██╔══╝██╔══██╗██║░░░░░
//    █████╗░░░╚███╔╝░██████╔╝█████╗░░██████╔╝██║██╔████╔██║█████╗░░██╔██╗██║░░░██║░░░███████║██║░░░░░
//    ██╔══╝░░░██╔██╗░██╔═══╝░██╔══╝░░██╔══██╗██║██║╚██╔╝██║██╔══╝░░██║╚████║░░░██║░░░██╔══██║██║░░░░░
//    ███████╗██╔╝╚██╗██║░░░░░███████╗██║░░██║██║██║░╚═╝░██║███████╗██║░╚███║░░░██║░░░██║░░██║███████╗
//    ╚══════╝╚═╝░░╚═╝╚═╝░░░░░╚══════╝╚═╝░░╚═╝╚═╝╚═╝░░░░░╚═╝╚══════╝╚═╝░░╚══╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝
//
//    ███████╗███████╗░█████╗░████████╗██╗░░░██╗██████╗░███████╗░██████╗
//    ██╔════╝██╔════╝██╔══██╗╚══██╔══╝██║░░░██║██╔══██╗██╔════╝██╔════╝
//    █████╗░░█████╗░░███████║░░░██║░░░██║░░░██║██████╔╝█████╗░░╚█████╗░
//    ██╔══╝░░██╔══╝░░██╔══██║░░░██║░░░██║░░░██║██╔══██╗██╔══╝░░░╚═══██╗
//    ██║░░░░░███████╗██║░░██║░░░██║░░░╚██████╔╝██║░░██║███████╗██████╔╝
//    ╚═╝░░░░░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═════╝░
//

    //MARK: Experimental Features
    func changeIcon(name: String?) {
            //Check if the app supports alternating icons
            guard UIApplication.shared.supportsAlternateIcons else {
                return
            }
            
            guard let name = name else {
                UIApplication.shared.setAlternateIconName(nil)
                return
            }
     
            //Change the icon to a specific image with given name
            UIApplication.shared.setAlternateIconName(name){ error in
                if let error = error {
                    print("Error:\n\n")
                    print(error.localizedDescription)
                    print("\n\n")
                }
            }
        }
     
    
    
    

    
}


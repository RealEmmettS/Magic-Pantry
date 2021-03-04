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
import GoogleMobileAds
import Qonversion
//import StoreKit



class ViewController: UIViewController, FUIAuthDelegate, AuthUIDelegate/*, SKProductsRequestDelegate, SKPaymentTransactionObserver*/{
    
    //    var premium: SKProduct?
    //
    //    func fetchProducts(){
    //        //dev.emmetts.MagicPantry.premiumpurchase
    //        let request = SKProductsRequest(productIdentifiers: ["dev.emmetts.MagicPantry.premiumpurchase"])
    //        request.delegate = self
    //        request.start()
    //    }
    //
    //    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    //        if let product = response.products.first {
    //            premium = product
    //            print(product.productIdentifier)
    //            print(product.localizedTitle)
    //            print(product.price)
    //        }
    //    }
    //
    //    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    //
    //        for transaction in transactions {
    //            switch transaction.transactionState {
    //            case .purchasing:
    //                //Do nothing here
    //                print("Purchasing...")
    //                break
    //            case .purchased, .restored:
    //                //unlock
    //                UserDefaults.standard.set(false, forKey: "doRunAds")
    //                self.purchaseButton.setTitle("Purchase Premium", for: .normal)
    //                SKPaymentQueue.default().finishTransaction(transaction)
    //                SKPaymentQueue.default().remove(self)
    //
    //            case .failed, .deferred:
    //                print("Failed to purchase")
    //                SKPaymentQueue.default().finishTransaction(transaction)
    //                SKPaymentQueue.default().remove(self)
    //            default:
    //                SKPaymentQueue.default().finishTransaction(transaction)
    //                SKPaymentQueue.default().remove(self)
    //            }
    //        }
    //    }
    
    
    private let banner: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = admobAppId
        if UserDefaults.standard.bool(forKey: "doRunAds") == true{
            print("Running ads pt.1")
            banner.load(GADRequest())
            banner.backgroundColor = .secondarySystemBackground
        }
        return banner
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UserDefaults.standard.bool(forKey: "doRunAds") == true{
            print("Running ads pt.2")
            banner.frame = CGRect(x: 0, y: view.frame.size.height - 50, width: view.frame.size.width, height: 50).integral
        }else{
            print("Won't run ads")
        }
    }
    
    
    
    func hideQonversion(){
        purchaseButton.isEnabled = false
        restoreButton.isEnabled = false
    }
    
    func showQonversion(){
        purchaseButton.isEnabled = true
        restoreButton.isEnabled = true
    }
    
    @IBOutlet weak var purchaseButton: UIButton!
    @IBAction func purchasePressed(_ sender: Any) {
        purchaseButton.setTitle("Loading...", for: .normal)
        
        print("Starting purchase procedure")
        Qonversion.purchase("premium") { (permissions, error, isCancelled) in
            
            if let Premium: Qonversion.Permission = permissions["Premium"], Premium.isActive {
                print("Purchase completed")
                UserDefaults.standard.set(false, forKey: "doRunAds")
                self.purchaseButton.setTitle("Purchase Premium", for: .normal)
                self.checkQonversionStatus()
            }else{
                print("Something went wrong with the purchase --See below for details")
                
                self.checkQonversionStatus()
                
                if error != nil{
                    print(error)
                }
                if isCancelled != nil{
                    print("Cancelled: \(isCancelled)")
                }
                self.purchaseButton.setTitle("Purchase Premium", for: .normal)
            }
        }
        
        //        purchaseButton.setTitle("Loading...", for: .normal)
        //        guard let premium = premium else {
        //            return
        //        }
        //
        //        if SKPaymentQueue.canMakePayments() {
        //            let payment = SKPayment(product: premium)
        //            SKPaymentQueue.default().add(self)
        //            SKPaymentQueue.default().add(payment)
        //
        //        }
        
    }
    
    @IBOutlet weak var restoreButton: UIButton!
    @IBAction func restorePressed(_ sender: Any) {
        
        
        
        self.restoreButton.setTitle("Loading...", for: .normal)
        
        Qonversion.restore { [weak self] (permissions, error) in
            if let error = error {
                // Handle error
                print("Restoring error")
                self?.restoreButton.setTitle("Restore Purchases", for: .normal)
            }
            print("Restoring")
            if let permission: Qonversion.Permission = permissions["Premium"], permission.isActive {
                // Restored and permission is active
                print("Restored")
                self?.restoreButton.setTitle("Restore Purchases", for: .normal)
                UserDefaults.standard.set(false, forKey: "doRunAds")
                self?.checkQonversionStatus()
            }else{
                print("Restoring failed. ")
                self?.restoreButton.setTitle("Restore Purchases", for: .normal)
            }
        }
    }
    
    func checkQonversionStatus(){
        Qonversion.checkPermissions { (permissions, error) in
            if error != nil {
                // handle error
                print("Qonversion error")
                return
            }
            
            if let premium: Qonversion.Permission = permissions["Premium"], premium.isActive {
                switch premium.renewState {
                case .willRenew, .nonRenewable:
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                case .billingIssue:
                    // Grace period: permission is active, but there was some billing issue.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    // Prompt the user to update the payment method.
                    break
                case .cancelled:
                    // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
                    // Prompt the user to resubscribe with a special offer.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                default: break
                }
            }else{
                UserDefaults.standard.set(true, forKey: "doRunAds")
                print("Qonversion: Premium Not Active")
            }
        }
    }
    
    
    
    //With the next two lines (@IBOutlet) we are simply connecting our User Interface elements to our code. This does nothing in particular besides let us access UI elements throught the code later on
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    
    //MARK: viewDidLoad and Setup
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        //UserDefaults.standard.set(false, forKey: "doRunAds")
        //fetchProducts()
        
        checkQonversionStatus()
        
        
        print("Running ads pt.3")
        if UserDefaults.standard.bool(forKey: "doRunAds") == true {
            banner.rootViewController = self
            view.addSubview(banner)
        }/*else{
            bottomConstraint.constant = 0
            self.updateViewConstraints()
        }*/
        
        
        //        IAPManager.shared.checkPermissions { (success) in
        //            if success {
        //                UserDefaults.standard.set(false, forKey: "doRunAds")
        //                print("Permissions found. Removing ads...")
        //            }else{
        //                UserDefaults.standard.set(true, forKey: "doRunAds")
        //            }
        //        }
        
        //UID.isHidden = true
        
        //overrideUserInterfaceStyle = .light
        
        
        UName = ""
        UserID = ""
        //Sets the name label to include the current user's name
        Name.text = "Please sign-in or refresh"
        //UID.text = "User ID: None"
        
        if Auth.auth().currentUser?.email != nil{
            UserIsLoggedIn = true
            showQonversion()
            updateQonversionUser()
        } else {
            UserIsLoggedIn = false
            hideQonversion()
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
            showQonversion()
            updateQonversionUser()
        } else {
            UserIsLoggedIn = false
            hideQonversion()
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
    
    
    /// Updates conversion user and rechecks the User account for subscription
    func updateQonversionUser(){
        Qonversion.setUserID(Auth.auth().currentUser!.uid)
        Qonversion.setProperty(.email, value: Auth.auth().currentUser!.email!)
        print("Qonversion User: \(Auth.auth().currentUser!.uid)")
        
        Qonversion.checkPermissions { (permissions, error) in
            if error != nil {
                // handle error
                print("Qonversion error")
                return
            }
            
            if let premium: Qonversion.Permission = permissions["Premium"], premium.isActive {
                switch premium.renewState {
                case .willRenew, .nonRenewable:
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                case .billingIssue:
                    // Grace period: permission is active, but there was some billing issue.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    // Prompt the user to update the payment method.
                    break
                case .cancelled:
                    // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
                    // Prompt the user to resubscribe with a special offer.
                    UserDefaults.standard.set(false, forKey: "doRunAds")
                    print("Qonversion: Premium Active")
                    break
                default: break
                }
            }else{
                UserDefaults.standard.set(true, forKey: "doRunAds")
                print("Qonversion: Premium Not Active")
            }
        }
    }
    
    
    
    //MARK: Functions
    func refreshVariables(){
        if Auth.auth().currentUser?.email != nil || Auth.auth().currentUser?.phoneNumber != nil{
            UName = Auth.auth().currentUser!.email!
            UserID = String(Auth.auth().currentUser!.uid)
            //Sets the name label to include the current user's name
            Name.text = "Email: \(UName!)"
            //UID.text = "User ID: \(UserID!)"
            signInButton.setTitle("Sign-Out", for: .normal)
            showQonversion()
            updateQonversionUser()
            //let userid = UUID().uuidString
        } else {
            print("User not logged in")
            hideQonversion()
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


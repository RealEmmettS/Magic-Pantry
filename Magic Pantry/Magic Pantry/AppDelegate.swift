//
//  AppDelegate.swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 12/26/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import GoogleSignIn
import GoogleMobileAds
import Qonversion

let doRunAds = UserDefaults.standard.bool(forKey: "doRunAds")
let admobAppId = "ca-app-pub-2690641987048640/4466175347"  //FOR PUBLIC RELEASE
//let admobAppId = "ca-app-pub-3940256099942544/2934735716"  //FOR TESTING ADMOB

//Paste ca-app-pub-2690641987048640~6775654239 in infor.plist for PUBLIC RELEASE
//Paste ca-app-pub-3940256099942544~1458002511 in infor.plist for TESTING ADMOB



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Firebase Config Code
        Qonversion.launch(withKey: "EZIGi-CcoBei3IhdzhXKRqiQ-RYH1YX4")
        FirebaseApp.configure()
        Qonversion.checkPermissions { (permissions, error) in
          if let error = error {
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
        
        if UserDefaults.standard.bool(forKey: "doRunAds") == true{
            GADMobileAds.sharedInstance().start(completionHandler: nil)

        }
        

        
        return true
    }
    

    

    
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
      if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
        return true
      }
      // other URL handling goes here.
      return false
    }
    
    
    
    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


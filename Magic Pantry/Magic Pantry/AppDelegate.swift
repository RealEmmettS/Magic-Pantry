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

let doRunAds = UserDefaults.standard.bool(forKey: "doRunAds")
let admobAppId = "ca-app-pub-2690641987048640/4466175347"  //FOR PUBLIC RELEASE
//let admobAppId = "ca-app-pub-3940256099942544/2934735716"  //FOR TESTING ADMOB



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Firebase Config Code
        FirebaseApp.configure()
        IAPManager.shared.configure { success in
            if success{
                print("Set up Qonversion")
                IAPManager.shared.checkPermissions { (success) in
                    if success {
                        //doRunAds = false
                        UserDefaults.standard.set(false, forKey: "doRunAds")
                        print("Permissions found. Removing ads...")
                    }else{
                        //doRunAds = true
                    }
                }
            }
        }
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        

        
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


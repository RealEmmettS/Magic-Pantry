//
//  IAPManager.swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 3/1/21.
//  Copyright © 2021 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import Qonversion

class IAPManager{
    static let shared = IAPManager()
    
    private init(){
        
    }
    
    ///////////////////////////////
    
    func configure(completion: @escaping (Bool) -> Void){
        //Qonversion.setUserID(<#T##userID: String##String#>)
        Qonversion.launch(withKey: "EZIGi-CcoBei3IhdzhXKRqiQ-RYH1YX4") { result, error in
            guard error == nil else {
                completion(false)
                return
            }
            
            completion(true)
            print("ID: " + result.uid)
            
        }
        
    }
    
    func checkPermissions(completion: @escaping (Bool) -> Void){
        Qonversion.checkPermissions { permissions, error  in
            guard error == nil else {
                print("error while checking permissions")
                return
            }
            
            print("Permissions: \(permissions)")
            if permissions.isEmpty {
                UserDefaults.standard.set(true, forKey: "doRunAds")
                completion(false)
            } else {
                UserDefaults.standard.set(false, forKey: "doRunAds")
            }
        }
    }
    
    func purchase(completion: @escaping (Bool) -> Void){
        Qonversion.purchase("premium") { (result, error, canceled) in
            guard error == nil else {
                completion(false)
                return
            }
            
            if canceled{
                print("Canceled transaction")
                completion(false)
            }else {
                completion(true)
            }
            
            
        }
        
    }
    
    
    func restorePurchases(completion: @escaping (Bool) -> Void){
        Qonversion.restore { (results, error) in
            guard error ==  nil else{
                return
            }
            
            print("Restored: \(results)")
        }
        
    }
    
}

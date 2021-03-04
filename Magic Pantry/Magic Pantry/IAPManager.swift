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
        
        Qonversion.checkPermissions { (permissions, error) in
            if let error = error {
                // handle error
                return
            }
            
            if let premium: Qonversion.Permission = permissions["Premium"], premium.isActive {
                switch premium.renewState {
                case .willRenew, .nonRenewable:
                    // .willRenew is the state of an auto-renewable subscription
                    // .nonRenewable is the state of consumable/non-consumable IAPs that could unlock lifetime access
                    break
                case .billingIssue:
                    // Grace period: permission is active, but there was some billing issue.
                    // Prompt the user to update the payment method.
                    break
                case .cancelled:
                    // The user has turned off auto-renewal for the subscription, but the subscription has not expired yet.
                    // Prompt the user to resubscribe with a special offer.
                    break
                default: break
                }
            }
        }
        
        
    }
    
    func purchase(completion: @escaping (Bool) -> Void){
        
        Qonversion.purchase("premium") { (permissions, error, isCancelled) in
            
            if let Premium: Qonversion.Permission = permissions["Premium"], Premium.isActive {
                // Flow for success state
            }
        }
        
    }
    
    
    func restorePurchases(completion: @escaping (Bool) -> Void){
        
        Qonversion.restore { [weak self] (permissions, error) in
            if let error = error {
                // Handle error
            }
            
            if let permission: Qonversion.Permission = permissions["Premium"], permission.isActive {
                // Restored and permission is active
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
}

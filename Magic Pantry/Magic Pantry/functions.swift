//
//  functions.swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 11/26/20.
//  Copyright © 2020 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {

    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}



/////////////////////////////

class functions{
    
    
    
    static func simpleAlert(title: String, message: String, action: String, ui: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))

        ui.present(alert, animated: true, completion: nil)
    }
    
    
    
}


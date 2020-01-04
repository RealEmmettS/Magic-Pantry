//
//  AppiconService.swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 12/29/19.
//  Copyright © 2019 Emmett Shaughnessy. All rights reserved.
//

import Foundation
import UIKit

class AppIconService {
    
    let application = UIApplication.shared
    
    enum AppIcon: String {
        case primaryAppIcon
        case MainIcon
        case OrignalIcon
    }
    
    func changeAppIcon(to appIcon: AppIcon) {
        //let appIconValue: String? = appIcon == .primaryAppIcon ? nil : appIcon.rawValue
        application.setAlternateIconName(appIcon.rawValue)
    }
    
    
    
}

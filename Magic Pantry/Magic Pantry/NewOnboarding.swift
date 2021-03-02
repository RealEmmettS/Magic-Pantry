//
//  NewOnboarding.swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 2/22/21.
//  Copyright © 2021 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import paper_onboarding

class NewOnboarding: UIViewController {

    @IBOutlet weak var onboardingView: PaperOnboarding!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
        
        continueButton.isHidden = true
        continueButton.isEnabled = false
        
        //The line below this one is for testing purposes only. DO NOT UNCOMMENT UNLESS YOU'RE TESTING ONBOARDING
        //UserDefaults.standard.set(false, forKey: "onboardingComplete")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "onboardingComplete") == true{
            print("Onboarding has been completed already")
            performSegue(withIdentifier: "moveToApp", sender: self)
        }else{
            UserDefaults.standard.set(true, forKey: "doRunAds")
        }
    
    }
    
    @IBAction func continuePressed(_ sender: Any) {
        
        UserDefaults.standard.set(true, forKey: "onboardingComplete")
        performSegue(withIdentifier: "moveToSignIn", sender: self)
        
    }
    
 

}





//          ███████╗██╗░░██╗████████╗███████╗███╗░░██╗░██████╗██╗░█████╗░███╗░░██╗░██████╗
//          ██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝████╗░██║██╔════╝██║██╔══██╗████╗░██║██╔════╝
//          █████╗░░░╚███╔╝░░░░██║░░░█████╗░░██╔██╗██║╚█████╗░██║██║░░██║██╔██╗██║╚█████╗░
//          ██╔══╝░░░██╔██╗░░░░██║░░░██╔══╝░░██║╚████║░╚═══██╗██║██║░░██║██║╚████║░╚═══██╗
//          ███████╗██╔╝╚██╗░░░██║░░░███████╗██║░╚███║██████╔╝██║╚█████╔╝██║░╚███║██████╔╝
//          ╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝╚═╝░░╚══╝╚═════╝░╚═╝░╚════╝░╚═╝░░╚══╝╚═════╝░





extension NewOnboarding: PaperOnboardingDataSource{
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        guard let MPTitleFont = UIFont(name: "PublicSans-ExtraBold", size: 40) else {
            fatalError("""
                Failed to load the "PublicSans-ExtraBold.otf" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        guard let MPDescFont = UIFont(name: "PublicSans-Light", size: 20) else {
            fatalError("""
                Failed to load the "PublicSans-Thin.otf" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        
        //https://coolors.co/ec3b3b-08abd9-36bf51
        let MPRedColor = UIColor(red: 0.92, green: 0.23, blue: 0.23, alpha: 1.00)
        let MPBlueColor = UIColor(red: 0.03, green: 0.67, blue: 0.85, alpha: 1.00)
        let MPGreenColor = UIColor(red: 0.21, green: 0.75, blue: 0.32, alpha: 1.00)

       return [
        OnboardingItemInfo(informationImage: UIImage(named: "MPApple")!,
                                       title: "Magic Pantry",
                                 description: "The lightning fast digital grocery list for everyone.\n\nMagic Pantry will backup your grocery lists to the cloud and sync your data accross all of your devices.",
                                 pageIcon: UIImage(named: "MPApple")!,
                                       color: MPRedColor,
                                  titleColor: UIColor.white,
                            descriptionColor: UIColor.white,
                            titleFont: MPTitleFont,
                             descriptionFont: MPDescFont),

        OnboardingItemInfo(informationImage: UIImage(named: "tap")!,
                                        title: "Get Started",
                                  description: "In the settings page, tap \"Sign-In\".\n\nThen, select a sign-in method\nand enter your information",
                                  pageIcon: UIImage(named: "MPApple")!,
                                  color: MPGreenColor,
                                   titleColor: UIColor.white,
                             descriptionColor: UIColor.white,
                             titleFont: MPTitleFont,
                              descriptionFont: MPDescFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "share")!,
                                        title: "Share Your Account",
                                  description: "If you want to sync your list with other family members, have them sign in to Magic Pantry with your account sign-in information.\n\nBe careful, and only share your account information with people you trust!",
                                  pageIcon: UIImage(named: "MPApple")!,
                                  color: MPBlueColor,
                                   titleColor: UIColor.white,
                             descriptionColor: UIColor.white,
                             titleFont: MPTitleFont,
                              descriptionFont: MPDescFont),

        OnboardingItemInfo(informationImage: UIImage(named: "list6")!,
                                     title: "Start Listing",
                               description: "Once you're signed in, click \n\"Go to Lists\"\n\nVoila! You're in and ready to begin making lists!",
                               pageIcon: UIImage(named: "MPApple")!,
                               color: MPRedColor,
                                titleColor: UIColor.white,
                          descriptionColor: UIColor.white,
                            titleFont: MPTitleFont,
                           descriptionFont: MPDescFont)
         ][index]
    }
}




extension NewOnboarding: PaperOnboardingDelegate{
    func onboardingDidTransitonToIndex(_ index: Int) {
        let page = index+1
        
        if page == 4{
            continueButton.isEnabled = true
            continueButton.isHidden = false
        } else {
            continueButton.isEnabled = false
            continueButton.isHidden = true
        }
    }
    
}

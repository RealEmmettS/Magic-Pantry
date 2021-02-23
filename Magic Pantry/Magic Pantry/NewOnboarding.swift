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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

 

}


extension NewOnboarding: PaperOnboardingDataSource{
    func onboardingItemsCount() -> Int {
        return 2
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        guard let MPTitleFont = UIFont(name: "PublicSans-ExtraBold", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "PublicSans-ExtraBold.otf" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        guard let MPDescFont = UIFont(name: "PublicSans-Thin", size: UIFont.labelFontSize) else {
            fatalError("""
                Failed to load the "PublicSans-ExtraBold.otf" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let MPRedColor = UIColor(red: 0.92, green: 0.23, blue: 0.23, alpha: 1.00)

       return [
        OnboardingItemInfo(informationImage: UIImage(named: "MPLogo")!,
                                       title: "title",
                                 description: "description",
                                 pageIcon: UIImage(named: "MPLogo")!,
                                       color: MPRedColor,
                                  titleColor: UIColor.white,
                            descriptionColor: UIColor.white,
                            titleFont: MPTitleFont,
                             descriptionFont: MPDescFont),

        OnboardingItemInfo(informationImage: UIImage(named: "MPLogo")!,
                                        title: "title",
                                  description: "description",
                                  pageIcon: UIImage(named: "MPLogo")!,
                                        color: MPRedColor,
                                   titleColor: UIColor.white,
                             descriptionColor: UIColor.white,
                             titleFont: MPTitleFont,
                              descriptionFont: MPDescFont),

        OnboardingItemInfo(informationImage: UIImage(named: "MPLogo")!,
                                     title: "title",
                               description: "description",
                               pageIcon: UIImage(named: "MPLogo")!,
                               color: MPRedColor,
                                titleColor: UIColor.white,
                          descriptionColor: UIColor.white,
                            titleFont: MPTitleFont,
                           descriptionFont: MPDescFont)
         ][index]
    }
}

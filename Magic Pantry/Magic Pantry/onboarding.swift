//
//  onboarding.swift
//  Magic Pantry
//
//  Created by Emmett Shaughnessy on 2/21/21.
//  Copyright © 2021 Emmett Shaughnessy. All rights reserved.
//

import UIKit
import paper_onboarding

class onboarding: PaperOnboarding {

    func onboardingItem(at index: Int) -> OnboardingItemInfo {

       return [
        OnboardingItemInfo(informationImage: UIImage(imageLiteralResourceName: "ItunesArtwork@2x.png"),
                                       title: "title",
                                 description: "description",
                                 pageIcon: UIImage(imageLiteralResourceName: "ItunesArtwork@2x.png"),
                                       color: UIColor.RANDOM,
                                  titleColor: UIColor.RANDOM,
                            descriptionColor: UIColor.RANDOM,
                                   titleFont: UIFont.FONT,
                             descriptionFont: UIFont.FONT),

        OnboardingItemInfo(informationImage: UIImage(imageLiteralResourceName: "ItunesArtwork@2x.png"),
                                        title: "title",
                                  description: "description",
                                  pageIcon: UIImage(imageLiteralResourceName: "ItunesArtwork@2x.png"),
                                        color: UIColor.RANDOM,
                                   titleColor: UIColor.RANDOM,
                             descriptionColor: UIColor.RANDOM,
                                    titleFont: UIFont.FONT,
                              descriptionFont: UIFont.FONT),

        OnboardingItemInfo(informationImage: UIImage(imageLiteralResourceName: "ItunesArtwork@2x.png"),
                                     title: "title",
                               description: "description",
                               pageIcon: UIImage(imageLiteralResourceName: "ItunesArtwork@2x.png"),
                                     color: UIColor.RANDOM,
                                titleColor: UIColor.RANDOM,
                          descriptionColor: UIColor.RANDOM,
                                 titleFont: UIFont.FONT,
                           descriptionFont: UIFont.FONT)
         ][index]
     }

     func onboardingItemsCount() -> Int {
        return 3
      }

}

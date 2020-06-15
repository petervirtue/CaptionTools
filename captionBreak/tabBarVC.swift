//
//  tabBarVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class tabBarVC: UITabBarController {
    
    //View controllers
    
    var home: UIViewController!
    var drafts: UIViewController!
    var hashtags: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Home
        
        home = LightNavigationController(rootViewController: homeVC.sharedInstance)
        home.title = "Create"
        home.tabBarItem.image = UIImage(systemName: "square.and.pencil")
        
        // Drafts
        
        drafts = LightNavigationController(rootViewController: draftsVC.sharedInstance)
        drafts.title = "Drafts"
        drafts.tabBarItem.image = UIImage(systemName: "folder")
        
        // Hashtags
        
        hashtags = LightNavigationController(rootViewController: hashtagsVC.sharedInstance)
        hashtags.title = "Hashtags"
        hashtags.tabBarItem.image = UIImage(systemName: "number.square")
        
        // Adding all view controllers
        
        self.viewControllers = [drafts, home, hashtags]
        self.selectedIndex = 1

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

//
//  tabBarVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class tabBarVC: UITabBarController {
    
    //View controller items
    var home: UIViewController!
    var drafts: UIViewController!
    var hashtags: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Home view controller
        home = LightNavigationController(rootViewController: homeVC.sharedInstance)
        home.title = "Create"
        home.tabBarItem.image = UIImage(systemName: "square.and.pencil")
        
        
        // Drafts
        
        drafts = LightNavigationController(rootViewController: draftsVC())
        drafts.title = "Title"
        drafts.tabBarItem.image = UIImage(systemName: "folder")
        
        // Hashtags
        
        hashtags = LightNavigationController(rootViewController: hashtagsVC())
        hashtags.title = "Hashtags"
        //TEMPORARY ICON
        hashtags.tabBarItem.image = UIImage(systemName: "briefcase")
        
        // Adding all view controllers
        self.viewControllers = [drafts, home, hashtags]
        self.selectedIndex = 1

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

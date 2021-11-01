//
//  TabBarController.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    //View controllers
    var home: UIViewController!
    var drafts: UIViewController!
    var hashtags: UIViewController!
    var user: UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Home

        home = NavController(rootViewController: HomeController.sharedInstance)
        home.title = "Create"
        home.tabBarItem.image = UIImage(systemName: "pencil.tip")
        
        // Drafts
        
        drafts = NavController(rootViewController: DraftsController.sharedInstance)
        drafts.title = "Drafts"
        drafts.tabBarItem.image = UIImage(systemName: "folder")
        
        // Hashtags
        
        hashtags = NavController(rootViewController: HashtagsController.sharedInstance)
        hashtags.title = "Hashtags"
        hashtags.tabBarItem.image = UIImage(systemName: "number")
        
        // User
        user = NavController(rootViewController: UserController.sharedInstance)
        user.title = "Profile"
        user.tabBarItem.image = UIImage(systemName: "person.fill")
        
        // Adding all view controllers
        
        self.viewControllers = [home, drafts, hashtags, user]
        self.selectedIndex = 0
        
        // Appearance
        
//        self.tabBar.standardAppearance.backgroundImage = UIImage().withTintColor(UIColor.systemGray6)
//        self.tabBar.standardAppearance.shadowImage = UIImage().withTintColor(UIColor.systemGray6)
    }
}

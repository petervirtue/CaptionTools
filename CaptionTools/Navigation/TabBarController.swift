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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = UIFont(name: "SanFranciscoDisplay-Light", size: 21)
        let bold_font = UIFont(name: "Montserrat-Bold", size: 12)
        self.tabBarItem.setTitleTextAttributes([.font: bold_font!], for: .normal)

        // Home
        home = NavController(rootViewController: HomeController.sharedInstance)
        home.title = "Create"
        home.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font!]
        home.tabBarItem.image = UIImage(systemName: "square.and.pencil")
        
        // Drafts
        
        drafts = NavController(rootViewController: DraftsController.sharedInstance)
        drafts.title = "Drafts"
        drafts.tabBarItem.image = UIImage(systemName: "folder")
        
        // Hashtags
        
        hashtags = NavController(rootViewController: HashtagsController.sharedInstance)
        hashtags.title = "Hashtags"
        hashtags.tabBarItem.image = UIImage(systemName: "number.square")
        
        // Adding all view controllers
        
        self.viewControllers = [drafts, home, hashtags]
        self.selectedIndex = 1
    }
}

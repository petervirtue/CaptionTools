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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Home view controller
        home = UINavigationController(rootViewController: homeVC.sharedInstance)
        home.title = "Create"
        home.tabBarItem.image = UIImage(systemName: "square.and.pencil")
        
        // Adding all view controllers
        self.viewControllers = [home]

    }
}

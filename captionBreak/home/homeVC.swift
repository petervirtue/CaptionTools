//
//  homeVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class homeVC: UIViewController {
    
    // Shared instance
    static let sharedInstance = homeVC()
    
    // Home view
    var home: homeView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        self.title = "Create"
        self.edgesForExtendedLayout = [UIRectEdge.bottom]
        
        // View
        home = homeView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        // Set the view to the home view
        self.view = home
        
        /*
        FUNCTIONALITY TO ADD
        - Line Breaks
        - Bold/Italic Support
        - Hashtag groupings
        - Save drafts
        */
        
    }
}

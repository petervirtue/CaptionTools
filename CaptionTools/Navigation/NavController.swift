//
//  NavController.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/11/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        
        // View did load
        super.viewDidLoad()
        
        // Montserrat
        guard let largeFont = UIFont(name: "Montserrat-Bold", size: 34) else {
            fatalError("""
                Failed to load the "Montserrat-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        guard let regularFont = UIFont(name: "Montserrat-Bold", size: 18) else {
            fatalError("""
                Failed to load the "Montserrat-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        guard let tabFont = UIFont(name: "Montserrat-Bold", size: 12) else {
            fatalError("""
                Failed to load the "Montserrat-Bold" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        // Navigation Design
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.init(named: "textColor")!, .font: regularFont]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.init(named: "textColor")!, .font: largeFont]
        appearance.backgroundColor = UIColor.init(named: "background")!
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.isTranslucent = true
        self.navigationBar.barTintColor = UIColor.init(named: "background")!
        self.navigationBar.tintColor = UIColor.init(named: "pink")!
        
        // Tab Bar Design
        self.tabBarItem.setTitleTextAttributes([.font: tabFont], for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

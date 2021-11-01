//
//  UserController.swift
//  captionBreak
//
//  Created by Peter Virtue on 10/31/21.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit

class UserController: UIViewController {
    
    // Shared Instance
    static let sharedInstance = UserController()
    
    // Components
    var csTitle: UILabel!
    var csSubTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        
        self.title = "Profile"
        
        // Setup
        
        setup()
    }
    
    func setup() {
        
        // Safe Area
        let l = self.view.safeAreaLayoutGuide
        
        // Background
        self.view.backgroundColor = UIColor.init(named: "background")!
        
        // Hiding the hairline
        self.navigationController?.hideHairline()
        
        // Tab bar controller
        if let tbc = self.tabBarController {
            if let items = tbc.tabBar.items
            {
                for item in items {
                    item.title = ""
                }
            }
        }
        
        // Coming Soon
        csTitle = UILabel(frame: .zero)
        csTitle.translatesAutoresizingMaskIntoConstraints = false
        csTitle.textAlignment = .center
        csTitle.font = UIFont(name: "Montserrat-Bold", size: 20)
        csTitle.textColor = UIColor.init(named: "textColor")!
        csTitle.text = "Coming Soon"
        
        let csTitleCons = [
            csTitle.leftAnchor.constraint(equalTo: l.leftAnchor),
            csTitle.rightAnchor.constraint(equalTo: l.rightAnchor),
            csTitle.topAnchor.constraint(equalTo: l.centerYAnchor, constant: -22.5),
            csTitle.bottomAnchor.constraint(equalTo: l.centerYAnchor)
        ]
        
        self.view.addSubview(csTitle)
        NSLayoutConstraint.activate(csTitleCons)
        
        // Coming Soon Subtitle
        csSubTitle = UILabel(frame: .zero)
        csSubTitle.translatesAutoresizingMaskIntoConstraints = false
        csSubTitle.textAlignment = .center
        csSubTitle.font = UIFont(name: "Montserrat", size: 14)
        csSubTitle.textColor = UIColor.systemGray
        csSubTitle.text = "Lots of new features on the way"
        
        let csSubTitleCons = [
            csSubTitle.leftAnchor.constraint(equalTo: l.leftAnchor),
            csSubTitle.rightAnchor.constraint(equalTo: l.rightAnchor),
            csSubTitle.topAnchor.constraint(equalTo: l.centerYAnchor),
            csSubTitle.bottomAnchor.constraint(equalTo: l.centerYAnchor, constant: 16.5)
        ]
        
        self.view.addSubview(csSubTitle)
        NSLayoutConstraint.activate(csSubTitleCons)
        
        // Settings
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings))
        
    }
    
    // Open settings
    
    @objc func openSettings() {
        // Feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Create and present vc
        let settings = SettingsController()
        settings.modalPresentationStyle = .overFullScreen
        present(settings, animated: false, completion: nil)
    }

}

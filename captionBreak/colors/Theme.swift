//
//  Theme.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/11/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    
    static var backgroundColor: UIColor!
    static var textColor: UIColor!
    
    static func setLightTheme(_ needsUpdate: [UIView]) {
        self.backgroundColor = UIColor.white
        self.textColor = UIColor.black
        
        for v in needsUpdate {
            v.update()
        }
    }
    
    static func setDarkTheme() {
        self.backgroundColor = UIColor.black
        self.textColor = UIColor.white
    }
}

//
//  homeView.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class homeView: UIView {
    
    // Components
    var captionIn: UITextView!
    var previewButton: UIButton!
    var shareButton: UIButton!
    var copyButton: UIButton!
    
    // Common width/height values
    var padWidth: CGFloat!
    var sa: UIEdgeInsets!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Safe area
        sa = UIEdgeInsets()
        
        
        
        
        // Values
        padWidth = self.frame.width - 40
        
        // Background
        self.backgroundColor = UIColor.cyan
        
        // Caption input
        captionIn = UITextView(frame: CGRect(x: 20, y: 20, width: padWidth, height: self.frame.height / 2))
        captionIn.backgroundColor = UIColor.green
        self.addSubview(captionIn)
    }
    
    // End edititng when tapping outside the buttons or text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

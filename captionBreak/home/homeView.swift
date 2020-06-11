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
    var toolbar: textEditBar!
    
    // Common width/height values
    var padWidth: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Safe area
        
        // Values
        padWidth = self.frame.width - 50
        
        // Background
        self.backgroundColor = UIColor.white
        
        // Caption input
        captionIn = UITextView(frame: CGRect(x: 20, y: 20, width: padWidth, height: self.frame.height - 274))
        captionIn.backgroundColor = UIColor.white
        captionIn.font = UIFont.systemFont(ofSize: 16)
        captionIn.textColor = UIColor.lightGray
        captionIn.text = "Start caption here..."
        self.addSubview(captionIn)
        
        // Keyboard toolbar
        toolbar = textEditBar(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44))
        toolbar.keyboardDown.addTarget(self, action: #selector(closeKeyboard), for: .touchUpInside)
        captionIn.inputAccessoryView = toolbar
        
        // Preview button
        previewButton = UIButton(frame: CGRect(x: 20, y: captionIn.frame.maxY + 20, width: padWidth / 5, height: 44))
        previewButton.setImage(UIImage(systemName: "person.crop.square.fill"), for: .normal)
        previewButton.backgroundColor = UIColor.darkGray
        previewButton.layer.cornerRadius = 2.5
        previewButton.clipsToBounds = true
        previewButton.tintColor = UIColor.white
        self.addSubview(previewButton)
        
        // Share button
        shareButton = UIButton(frame: CGRect(x: previewButton.frame.maxX + 5, y: captionIn.frame.maxY + 20, width: padWidth / 5, height: 44))
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.backgroundColor = UIColor.darkGray
        shareButton.layer.cornerRadius = 2.5
        shareButton.clipsToBounds = true
        shareButton.tintColor = UIColor.white
        self.addSubview(shareButton)
        
        // Copy button
        copyButton = UIButton(frame: CGRect(x: shareButton.frame.maxX + 5, y: captionIn.frame.maxY + 20, width: (padWidth / 5) * 3, height: 44))
        copyButton.setTitle("Copy to Clipboard", for: .normal)
        copyButton.backgroundColor = UIColor.darkGray
        copyButton.layer.cornerRadius = 2.5
        copyButton.clipsToBounds = true
        copyButton.tintColor = UIColor.white
        self.addSubview(copyButton)
        
        
    }
    
    // End edititng when tapping outside the buttons or text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    // Close the keyboard
    @objc func closeKeyboard(_ sender: UIButton) {
        self.endEditing(true)
    }
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

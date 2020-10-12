//
//  textEditBar.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit



class textEditBar: UIView {
    
    // Components
    
    var normal: UIButton!
    var bold: UIButton!
    var italic: UIButton!
    var hashtags: UIButton!
    var keyboardDown: UIButton!
    var clear: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Background
        self.backgroundColor = UIColor.init(named: "element")!
        
        // Normal
        normal = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width / 6, height: self.frame.height))
        normal.setImage(UIImage(systemName: "a"), for: .normal)
        normal.tintColor = UIColor.init(named: "textColor")!
        self.addSubview(normal)
        
        // Bold
        bold = UIButton(frame: CGRect(x: normal.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        bold.setImage(UIImage(systemName: "bold"), for: .normal)
        bold.tintColor = UIColor.systemGray3
        self.addSubview(bold)
        
        // Italic
        italic = UIButton(frame: CGRect(x: bold.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        italic.setImage(UIImage(systemName: "italic"), for: .normal)
        italic.tintColor = UIColor.systemGray3
        self.addSubview(italic)
        
        // Clear
        clear = UIButton(frame: CGRect(x: italic.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        clear.setImage(UIImage(systemName: "trash"), for: .normal)
        clear.tintColor = UIColor.systemGray3
        self.addSubview(clear)
        
        // Hashtags
        hashtags = UIButton(frame: CGRect(x: clear.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        hashtags.setImage(UIImage(systemName: "number"), for: .normal)
        hashtags.tintColor = UIColor.systemGray3
        self.addSubview(hashtags)
        
        // Keyboard Down
        keyboardDown = UIButton(frame: CGRect(x: hashtags.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        keyboardDown.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        keyboardDown.tintColor = UIColor.systemGray3
        self.addSubview(keyboardDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

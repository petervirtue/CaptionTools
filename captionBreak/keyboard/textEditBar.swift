//
//  textEditBar.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

enum typeStyle {
    case normal, bold, italic
}

class textEditBar: UIView {
    
    var normal: UIButton!
    var bold: UIButton!
    var italic: UIButton!
    var hashtags: UIButton!
    var keyboardDown: UIButton!
    var clear: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Background
        self.backgroundColor = .white
        
        // Normal
        normal = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width / 6, height: self.frame.height))
        normal.setImage(UIImage(systemName: "a"), for: .normal)
        normal.tintColor = .black
        self.addSubview(normal)
        
        // Bold
        bold = UIButton(frame: CGRect(x: normal.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        bold.setImage(UIImage(systemName: "bold"), for: .normal)
        bold.tintColor = Colors.gray
        self.addSubview(bold)
        
        // Italic
        italic = UIButton(frame: CGRect(x: bold.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        italic.setImage(UIImage(systemName: "italic"), for: .normal)
        italic.tintColor = Colors.gray
        self.addSubview(italic)
        
        // Clear
        clear = UIButton(frame: CGRect(x: italic.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        clear.setImage(UIImage(systemName: "trash"), for: .normal)
        clear.tintColor = Colors.gray
        self.addSubview(clear)
        
        // Hashtags
        hashtags = UIButton(frame: CGRect(x: clear.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        hashtags.setTitle("#", for: .normal)
        hashtags.setTitleColor(Colors.gray, for: .normal)
        hashtags.tintColor = Colors.gray
        self.addSubview(hashtags)
        
        // Keyboard Down
        keyboardDown = UIButton(frame: CGRect(x: hashtags.frame.maxX, y: 0, width: self.frame.width / 6, height: self.frame.height))
        keyboardDown.setImage(UIImage(systemName: "keyboard.chevron.compact.down"), for: .normal)
        keyboardDown.tintColor = Colors.gray
        self.addSubview(keyboardDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

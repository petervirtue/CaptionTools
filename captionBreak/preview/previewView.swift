//
//  previewView.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class previewView: UIView {
    
    // Components
    var image: UIImageView!
    var addedText: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        // Image View
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: (self.frame.width * 589) / 375))
        image.image = UIImage(#imageLiteral(resourceName: "preview"))
        self.addSubview(image)
        
        // Added text
        addedText = UITextView(frame: CGRect(x: 10, y: image.frame.maxY, width: self.frame.width - 20, height: self.frame.height - image.frame.height))
        addedText.backgroundColor = .white
        addedText.textColor = .black
        addedText.isEditable = false
        self.addSubview(addedText)
        
    }
    
    func setup(_ s: NSMutableAttributedString) {
        
        // Instagram name
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 14)
        ]
        
        s.prepareForPreview()
        let ms = NSMutableAttributedString(string: "instagram ", attributes: attrs)
        ms.append(s)
        addedText.attributedText = ms
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

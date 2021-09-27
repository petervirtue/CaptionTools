//
//  HashtagTextField.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/17/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit

class HashtagTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

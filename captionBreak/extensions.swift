//
//  extensions.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

extension NSMutableAttributedString {
    
    // Change font size
    func changeFontSize(to: CGFloat) {
        beginEditing()
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            if let f = value as? UIFont {
                let newF = UIFont(descriptor: f.fontDescriptor, size: to)
                removeAttribute(.font, range: range)
                addAttribute(.font, value: newF, range: range)
            }
        }
        endEditing()
    }
    
    // Prepare for preview
    func prepareForPreview() {
        
        // Change size first, then color
        self.changeFontSize(to: 14)
        
        // Color
        beginEditing()
        self.enumerateAttribute(.font, in: NSRange(location: 0, length: self.length)) { (value, range, stop) in
            removeAttribute(.foregroundColor, range: range)
            addAttribute(.foregroundColor, value: UIColor.black, range: range)
        }
        
        endEditing()
    }
}

extension UIPasteboard {
    func set(attributedString: NSAttributedString?) {
        guard let attributedString = attributedString else { return }
        
        do {
            let rtf = try attributedString.data(from: NSRange(location: 0, length: attributedString.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])
            items = [[kUTTypeRTF as String: NSString(data: rtf, encoding: String.Encoding.utf8.rawValue)!, kUTTypeUTF8PlainText as String: attributedString.string]]
            
        } catch {
            
        }
    }
}

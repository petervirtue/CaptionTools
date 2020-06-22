//
//  Hashtag.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/15/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import Foundation


public class HashtagObject: NSObject, NSCoding {
    
    public var attributedStrings: [NSAttributedString] = []
    
    enum Key: String {
        case attributedStrings = "attributedStrings"
    }
    
    init(attributedStrings: [NSAttributedString]) {
        self.attributedStrings = attributedStrings
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(attributedStrings, forKey: Key.attributedStrings.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let atts = aDecoder.decodeObject(forKey: Key.attributedStrings.rawValue) as! [NSAttributedString]
        
        self.init(attributedStrings: atts)
    }
    
}

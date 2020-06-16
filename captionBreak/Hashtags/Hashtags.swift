//
//  Hashtag.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/15/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import Foundation


public class Hashtags: NSObject, NSCoding {
    
    public var hashtags: [NSAttributedString] = []
    
    enum Key: String {
        case hashtags = "hashtags"
    }
    
    init(hashtags: [NSAttributedString]) {
        self.hashtags = hashtags
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(hashtags, forKey: Key.hashtags.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mHashtags = aDecoder.decodeObject(forKey: Key.hashtags.rawValue) as! [NSAttributedString]
        
        self.init(hashtags: mHashtags)
    }
    
}

//
//  editorCell.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/16/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class editorCell: UITableViewCell {
    
    // Components
    
    var hashtagLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        // Initialization code
        
        self.selectionStyle = .none
        
        // Hashtag label
        
        hashtagLabel = UILabel()
        hashtagLabel.textColor = UIColor.black
        hashtagLabel.font = UIFont.systemFont(ofSize: 16)
        hashtagLabel.backgroundColor = UIColor.white
        hashtagLabel.layer.cornerRadius = 5
        hashtagLabel.clipsToBounds = true
        hashtagLabel.isUserInteractionEnabled = false
        hashtagLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let hashtagCons = [
            hashtagLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            hashtagLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            hashtagLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            hashtagLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
        ]
        
        self.contentView.addSubview(hashtagLabel)
        
        NSLayoutConstraint.activate(hashtagCons)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

//
//  draftCell.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/12/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class draftCell: UITableViewCell {
    
    // Components
    
    var textView: UITextView!
    var label: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        // Background color
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        // Text view
        
        textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        //textView.textContainer.maximumNumberOfLines = 6
        textView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        let textViewCons = [
            textView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            textView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            textView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
        ]
        
        self.contentView.addSubview(textView)
        
        NSLayoutConstraint.activate(textViewCons)
        
    }
    
    @objc func setSelectedFromTextView() {
        self.setSelected(true, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

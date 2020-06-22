//
//  hashtagCell.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/15/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class hashtagCell: UITableViewCell {
    
    // Components
    
    var backPlate: UIView!
    var textView: UITextView!
    var label: UILabel!
    var editArrow: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Background color
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        // Back plate
        
        backPlate = UIView()
        backPlate.backgroundColor = UIColor.white
        backPlate.isUserInteractionEnabled = false
        backPlate.translatesAutoresizingMaskIntoConstraints = false
        backPlate.layer.cornerRadius = 4
        
        let backCons = [
            backPlate.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            backPlate.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            backPlate.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            backPlate.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5)
        ]
        
        self.contentView.addSubview(backPlate)
        
        NSLayoutConstraint.activate(backCons)
        
        // Label
        
        label = UILabel()
        label.isUserInteractionEnabled = false
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.white
        
        let labelCons = [
            label.leftAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 12),
            label.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -25),
            label.bottomAnchor.constraint(equalTo: backPlate.topAnchor, constant: 30),
            label.topAnchor.constraint(equalTo: backPlate.topAnchor, constant: 10)
        ]
        
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate(labelCons)
        
        // Text view
        
        textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        let textViewCons = [
            textView.leftAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -25),
            textView.bottomAnchor.constraint(equalTo: backPlate.bottomAnchor, constant: -10),
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ]
        
        self.contentView.addSubview(textView)
        
        NSLayoutConstraint.activate(textViewCons)
        
        // Edit arrow
        
        editArrow = UIImageView(frame: .zero)
        editArrow.image = UIImage(systemName: "chevron.right")
        editArrow.tintColor = .gray
        editArrow.translatesAutoresizingMaskIntoConstraints = false
        
        let arrowCons = [
            editArrow.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 5),
            editArrow.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -10),
            editArrow.bottomAnchor.constraint(equalTo: backPlate.centerYAnchor, constant: 10),
            editArrow.topAnchor.constraint(equalTo: backPlate.centerYAnchor, constant: -10)
        ]
        
        self.addSubview(editArrow)
        
        NSLayoutConstraint.activate(arrowCons)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

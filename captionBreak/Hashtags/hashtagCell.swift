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
    var seperator: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Background color
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        self.selectedBackgroundView = nil
        
        // Back plate
        
        backPlate = UIView()
        backPlate.backgroundColor = UIColor.init(named: "element")!
        backPlate.isUserInteractionEnabled = false
        backPlate.translatesAutoresizingMaskIntoConstraints = false
        
        let backCons = [
            backPlate.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            backPlate.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            backPlate.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            backPlate.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0)
        ]
        
        self.contentView.addSubview(backPlate)
        
        NSLayoutConstraint.activate(backCons)
        
        // Seperator line
        
        seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = UIColor.systemGray3
        
        let seperatorCons = [
            seperator.leftAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 16),
            seperator.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -16),
            seperator.bottomAnchor.constraint(equalTo: backPlate.topAnchor, constant: 1),
            seperator.topAnchor.constraint(equalTo: backPlate.topAnchor, constant: 0)
        ]
        
        self.contentView.addSubview(seperator)
        
        NSLayoutConstraint.activate(seperatorCons)
        
        // Label
        
        label = UILabel()
        label.isUserInteractionEnabled = false
        label.textColor = UIColor.init(named: "textColor")!
        label.font = UIFont(name: "Montserrat-Bold", size: 18)//UIFont.boldSystemFont(ofSize: 18)
        label.layer.cornerRadius = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.init(named: "element")!
        
        let labelCons = [
            label.leftAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -31),
            label.bottomAnchor.constraint(equalTo: backPlate.topAnchor, constant: 32),
            label.topAnchor.constraint(equalTo: backPlate.topAnchor, constant: 12)
        ]
        
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate(labelCons)
        
        // Text view
        
        textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor.init(named: "textColor")!
        textView.backgroundColor = UIColor.init(named: "element")!
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        
        let textViewCons = [
            textView.leftAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 16),
            textView.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -31),
            textView.bottomAnchor.constraint(equalTo: backPlate.bottomAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
        ]
        
        self.contentView.addSubview(textView)
        
        NSLayoutConstraint.activate(textViewCons)
        
        // Edit arrow
        
        editArrow = UIImageView(frame: .zero)
        editArrow.image = UIImage(systemName: "chevron.right")
        editArrow.tintColor = UIColor.systemGray3
        editArrow.translatesAutoresizingMaskIntoConstraints = false
        
        let arrowCons = [
            editArrow.leftAnchor.constraint(equalTo: textView.rightAnchor, constant: 5),
            editArrow.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -16),
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

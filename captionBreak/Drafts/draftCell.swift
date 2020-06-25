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
    
    var backPlate: UIView!
    var label: UILabel!
    var textView: UITextView!
    var editArrow: UIImageView!
    var shadowPlate: ShadowView!
    var seperator: UIView!

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
        //backPlate.layer.cornerRadius = 5
        
        // Cosmetic updates for a future update
        
        /*
        backPlate.layer.shadowOffset = CGSize(width: 0, height: 3)
        backPlate.layer.shadowRadius = 3
        backPlate.layer.shadowOpacity = 0.3
        backPlate.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: 5, cornerHeight: 5, transform: nil)//UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 5, height: 5))
        backPlate.layer.shouldRasterize = true
        backPlate.layer.rasterizationScale = UIScreen.main.scale */
        
        let backCons = [
            backPlate.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            backPlate.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            backPlate.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            backPlate.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0)
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
        //label.backgroundColor = UIColor.white
        
        let labelCons = [
            label.leftAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 10),
            label.rightAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 32),
            label.bottomAnchor.constraint(equalTo: backPlate.topAnchor, constant: 32),
            label.topAnchor.constraint(equalTo: backPlate.topAnchor, constant: 12)
        ]
        
        self.contentView.addSubview(label)
        
        NSLayoutConstraint.activate(labelCons)
        
        // Seperator line
        
        seperator = UIView(frame: .zero)
        seperator.translatesAutoresizingMaskIntoConstraints = false
        seperator.backgroundColor = Colors.backGray
        
        let seperatorCons = [
            seperator.leftAnchor.constraint(equalTo: backPlate.leftAnchor, constant: 20),
            seperator.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: 0),
            seperator.bottomAnchor.constraint(equalTo: backPlate.topAnchor, constant: 1),
            seperator.topAnchor.constraint(equalTo: backPlate.topAnchor, constant: 0)
        ]
        
        self.contentView.addSubview(seperator)
        
        NSLayoutConstraint.activate(seperatorCons)
        
        // Text view
        
        textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor.black
        textView.backgroundColor = .white//Colors.backGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 5
        textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        //textView.textContainer.maximumNumberOfLines = 6
        textView.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        
        let textViewCons = [
            textView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 5),
            textView.rightAnchor.constraint(equalTo: backPlate.rightAnchor, constant: -25),
            textView.bottomAnchor.constraint(equalTo: backPlate.bottomAnchor, constant: -5),
            textView.topAnchor.constraint(equalTo: backPlate.topAnchor, constant: 5)
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
    
    @objc func setSelectedFromTextView() {
        self.setSelected(true, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

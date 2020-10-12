//
//  previewVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class previewVC: UIViewController {
    
    
    var pv: previewView!
    var mas: NSMutableAttributedString!
    
    // Components
    
    var insta: UIImageView!
    var addedText: UITextView!
    var close: UIButton!
    var dragbar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        /*// Setup
        
        pv = previewView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height))
        pv.setup(mas)
        self.view = pv*/
        
        // Setup
        
        setup()
        
        
        
    }
    
    // Setup
    
    func setup() {
        
        // Safe layout guide
        
        let l = self.view.safeAreaLayoutGuide
        
        // Background color
        
        self.view.backgroundColor = UIColor.init(named: "background3")!
        
        // Insta View
        
        insta = UIImageView(frame: .zero)
        insta.image = UIImage(#imageLiteral(resourceName: "previewBoth"))
        insta.translatesAutoresizingMaskIntoConstraints = false
        
        print(self.view.frame.width)
        
        let height = ((self.view.frame.width) * 1477) / 1125
        
        print(height)
        
        let instaCons = [
            insta.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 0),
            insta.rightAnchor.constraint(equalTo: l.rightAnchor, constant: 0),
            insta.topAnchor.constraint(equalTo: l.topAnchor, constant: 16),
            insta.bottomAnchor.constraint(equalTo: l.topAnchor, constant: height + 16)
        ]
        
        self.view.addSubview(insta)
        
        NSLayoutConstraint.activate(instaCons)
        
        // Added text
        addedText = UITextView(frame: .zero)
        addedText.backgroundColor = UIColor.init(named: "background3")!
        addedText.textColor = UIColor.init(named: "textColor")!
        addedText.isEditable = false
        addedText.translatesAutoresizingMaskIntoConstraints = false
        addedText.isScrollEnabled = false
        addedText.textContainer.maximumNumberOfLines = 5
        addedText.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        addedText.textContainerInset = UIEdgeInsets.zero
        addedText.textContainer.lineFragmentPadding = 0
        
        let addedTextCons = [
            addedText.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 16),
            addedText.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -16),
            addedText.topAnchor.constraint(equalTo: insta.bottomAnchor, constant: 0),
            addedText.bottomAnchor.constraint(equalTo: insta.bottomAnchor, constant: 80)
        ]
        
        self.view.addSubview(addedText)
        
        NSLayoutConstraint.activate(addedTextCons)
        
        // Close
        
        close = UIButton(frame: .zero)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.backgroundColor = UIColor.init(named: "background3")!
        close.tintColor = UIColor.init(named: "pink")!
        
        let closeCons = [
            close.leftAnchor.constraint(equalTo: l.rightAnchor, constant: -55),
            close.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -15),
            close.topAnchor.constraint(equalTo: l.topAnchor, constant: 24),
            close.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 64)
        ]
        
        self.view.addSubview(close)
        
        NSLayoutConstraint.activate(closeCons)
        
        // Drag bar
        
        dragbar = UIView(frame: .zero)
        dragbar.backgroundColor = UIColor.gray
        dragbar.layer.cornerRadius = 2.5
        dragbar.translatesAutoresizingMaskIntoConstraints = false
        
        let dragbarCons = [
            dragbar.leftAnchor.constraint(equalTo: l.centerXAnchor, constant: -20),
            dragbar.rightAnchor.constraint(equalTo: l.centerXAnchor, constant: 20),
            dragbar.topAnchor.constraint(equalTo: l.topAnchor, constant: 10),
            dragbar.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 15)
        ]
        
        self.view.addSubview(dragbar)
        
        NSLayoutConstraint.activate(dragbarCons)
        
        // Add caption
        
        addCaption(mas)
        
        // Targets
        
        close.addTarget(self, action: #selector(closeVC), for: .touchUpInside)
        
    }
    
    // Add caption to the VC
    
    func addCaption(_ c: NSMutableAttributedString) {
        
        // Instagram name
        
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: UIColor.init(named: "textColor")!
        ]
        
        let attrs2: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.init(named: "textColor")!
        ]
        
        // Adding to the preview
        
        c.prepareForPreview()
        let c2 = NSAttributedString(string: c.string, attributes: attrs2)
        let ms = NSMutableAttributedString(string: "instagram ", attributes: attrs)
        ms.append(c2)
        addedText.attributedText = ms
    }
    
    @objc func closeVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

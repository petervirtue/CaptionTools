//
//  extensions.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
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

extension UIView {
    
    func setGradient(colors: [UIColor?]) -> CAGradientLayer {
        return self.setGradient(colors: colors, locations: nil)
    }
    
    func setGradient(colors: [UIColor?], locations: [NSNumber]?) -> CAGradientLayer {
        let grad = CAGradientLayer()
        grad.frame = self.bounds
        grad.colors = colors.map { $0!.cgColor }
        grad.locations = locations
        grad.startPoint = CGPoint(x: 0, y: 0)
        grad.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(grad, at: 0)
        return grad
    }
    
    func update() {
        self.setNeedsDisplay()
        
        for v in self.subviews {
            v.update()
        }
    }
    
    func constraint(withID: String) -> NSLayoutConstraint? {
        return self.constraints.filter{ $0.identifier == withID }.first
    }
    
    func roundTopCorners(radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}

extension NSLayoutAnchor {
    @objc func constraintEqualToAnchor(_ anchor: NSLayoutAnchor, constant: CGFloat, id: String) -> NSLayoutConstraint {
        let con = self.constraint(equalTo: anchor, constant: constant)
        con.identifier = id
        return con
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension NSData {
    func toAttributedString() -> NSAttributedString? {
        let data = Data(referencing: self)
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]
        
        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
}

extension NSAttributedString {
    func toNSData() -> NSData? {
        let options : [NSAttributedString.DocumentAttributeKey: Any] = [
            .documentType: NSAttributedString.DocumentType.rtfd,
            .characterEncoding: String.Encoding.utf8
        ]
        
        let range = NSRange(location: 0, length: length)
        guard let data = try? data(from: range, documentAttributes: options) else {
            return nil
        }
        
        return NSData(data: data)
    }
}

extension UITableView {
    
    func setEmptyView(title: String, sub: String) {
        
        // Components
        
        let ev = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let subLabel = UILabel()
        
        // Title label
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.init(named: "textColor")!
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.text = title
        
        let titleCons = [
            titleLabel.centerXAnchor.constraint(equalTo: ev.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: ev.centerYAnchor, constant: 0),
        ]
        
        ev.addSubview(titleLabel)
        
        NSLayoutConstraint.activate(titleCons)
        
        // Sub label
    
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.textColor = UIColor.systemGray3
        subLabel.font = UIFont.systemFont(ofSize: 17)
        subLabel.numberOfLines = 0
        subLabel.textAlignment = .center
        subLabel.text = sub
        
        let subCons = [
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subLabel.leftAnchor.constraint(equalTo: ev.leftAnchor, constant: 20),
            subLabel.rightAnchor.constraint(equalTo: ev.rightAnchor, constant: -20)
        ]
        
        ev.addSubview(subLabel)
        
        NSLayoutConstraint.activate(subCons)
        
        // Set the background
        
        self.backgroundView = ev
        //self.separatorStyle = .none
    }
    
    func restoreFromEmpty() {
        
        self.backgroundView = nil
        //self.separatorStyle = .singleLine
    }
}

extension String {
    func amountOfHashtags() -> Int {
        var count = 0
        let words = NSString(string: self).components(separatedBy: " ")
        
        for word in words {
            if word.hasPrefix("#") {
                count = count + 1
            }
        }
        
        return count
    }
}

extension UINavigationController {

    func hideHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = true
        }
    }
    func restoreHairline() {
        if let hairline = findHairlineImageViewUnder(navigationBar) {
            hairline.isHidden = false
        }
    }
    func findHairlineImageViewUnder(_ view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            if let imageView = self.findHairlineImageViewUnder(subview) {
                return imageView
            }
        }
        return nil
    }
}

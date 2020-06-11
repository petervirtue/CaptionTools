//
//  homeVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit
import Foundation

class homeVC: UIViewController, UITextViewDelegate {
    
    // Shared instance
    static let sharedInstance = homeVC()
    
    // Home view
    var home: homeView!
    
    // Editing status
    var typeStatus: typeStyle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        self.title = "Create"
        self.edgesForExtendedLayout = []
        
        // Keyboard handling
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // View
        home = homeView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height))
        home.captionIn.delegate = self
        home.copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
        home.shareButton.addTarget(self, action: #selector(shareText), for: .touchUpInside)
        home.previewButton.addTarget(self, action: #selector(showPreview), for: .touchUpInside)
        home.toolbar.normal.addTarget(self, action: #selector(setNormal), for: .touchUpInside)
        home.toolbar.bold.addTarget(self, action: #selector(setBold), for: .touchUpInside)
        home.toolbar.italic.addTarget(self, action: #selector(setItalic), for: .touchUpInside)
        
        // Set the view to the home view
        self.view = home
        
        // Initial type style
        typeStatus = .normal
        
        /*
        FUNCTIONALITY TO ADD
        - Line Breaks
        - Bold/Italic Support
        - Hashtag groupings
        - Save drafts
        */
        
    }
    
    // Show preview
    @objc func showPreview(_ sender: UIButton) {
        
        // Get text
        let mas = NSMutableAttributedString(attributedString: home.captionIn.attributedText)
        print(mas)
        
        // Setup view controller
        let pvc = previewVC()
        pvc.mas = mas
        self.present(pvc, animated: true, completion: nil)
    }
    
    // Share text
    @objc func shareText(_ sender: UIButton) {
        
        // Get text
        let text = home.captionIn.text
        
        let share = [text]
        let ac = UIActivityViewController(activityItems: share, applicationActivities: nil)
        self.present(ac, animated: true, completion: nil)
    }
    
    // Copy to clipboard
    @objc func copyToClipboard(_ sender: UIButton) {
        // Set the text
        UIPasteboard.general.set(attributedString: home.captionIn.attributedText)
        
        // Original text
        let original = sender.title(for: .normal)
        
        // Change the button text
        sender.setTitle("Copied!", for: .normal)
        
        // Change it back
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.setTitle(original, for: .normal)
        }
    }
    
    @objc func setNormal(_ sender: UIButton) {
        
        // Set text kind
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 16)
        ]
        
        home.captionIn.typingAttributes = attrs
        
        // Edit the buttons
        home.toolbar.bold.tintColor = .gray
        home.toolbar.italic.tintColor = .gray
        home.toolbar.hashtags.tintColor = .gray
        home.toolbar.keyboardDown.tintColor = .gray
        home.toolbar.normal.tintColor = .black
    }
    
    @objc func setBold(_ sender: UIButton) {
        
        // Set text kind
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 16)
        ]
        
        home.captionIn.typingAttributes = attrs
        
        // Edit the buttons
        home.toolbar.bold.tintColor = .black
        home.toolbar.italic.tintColor = .gray
        home.toolbar.hashtags.tintColor = .gray
        home.toolbar.keyboardDown.tintColor = .gray
        home.toolbar.normal.tintColor = .gray
        
    }
    
    @objc func setItalic(_ sender: UIButton) {
        
        // Set text kind
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.italicSystemFont(ofSize: 16)
        ]
        
        home.captionIn.typingAttributes = attrs
        
        // Edit the buttons
        home.toolbar.bold.tintColor = .gray
        home.toolbar.italic.tintColor = .black
        home.toolbar.hashtags.tintColor = .gray
        home.toolbar.keyboardDown.tintColor = .gray
        home.toolbar.normal.tintColor = .gray
    }
    
    // Placeholder removal
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // Placeholder
        if home.captionIn.textColor == UIColor.lightGray {
            home.captionIn.text = nil
            home.captionIn.textColor = UIColor.black
        }
        
    }
    
    
    // Placeholder put back
    func textViewDidEndEditing(_ textView: UITextView) {
        if home.captionIn.text.isEmpty {
            home.captionIn.text = "Start caption here..."
            home.captionIn.textColor = UIColor.lightGray
        }
    }
    
    // Keyboard will show
    @objc func keyboardWillShow(_ notification: Notification) {
        
        // Keyboard Size
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let kFrame = keyboardSize.cgRectValue
        let previous = home.captionIn.frame.height
        home.captionIn.frame = CGRect(x: home.captionIn.frame.minX, y: home.captionIn.frame.minY, width: home.captionIn.frame.width, height: previous - kFrame.height / 2 - 50)
        
         // Adjusting view size
        if self.view.frame.origin.y == 0 {
            //self.view.frame.origin.y -= kFrame.height
        }
    }
    
    // Keyboard will hide
    @objc func keyboardWillHide(_ notification: Notification) {
        // Keyboard Size
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let kFrame = keyboardSize.cgRectValue
        let previous = home.captionIn.frame.height
        home.captionIn.frame = CGRect(x: home.captionIn.frame.minX, y: home.captionIn.frame.minY, width: home.captionIn.frame.width, height: previous + kFrame.height / 2 + 50)
    }
}

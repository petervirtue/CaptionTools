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
    
    // Components
    
    var captionIn: UITextView!
    var previewButton: UIButton!
    var shareButton: UIButton!
    @objc var copyButton: UIButton!
    var toolbar: textEditBar!
    var charactersUsed: UILabel!
    var hashtagsUsed: UILabel!
    var bottomPlate: UIView!
    //var gradient: UIView!
    //var gradLayer: CAGradientLayer!
    
    // Bottom constraint for Text Field
    
    var captionInBottom: NSLayoutConstraint!

    // Editing status
    
    var typeStatus: typeStyle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        
        self.title = "Create"
        self.edgesForExtendedLayout = []
        
        // Run Setup
        
        setup()
        
        // Text View Delegate
        
        captionIn.delegate = self
        
        // Initial type status
        
        typeStatus = .normal
        
        /*
        FUNCTIONALITY TO ADD
        - Line Breaks
        - Bold/Italic Support
        - Hashtag groupings
        - Save drafts
        */
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setup() {
        
        // Safe Area
        
        let l = self.view.safeAreaLayoutGuide
        
        // View
        
        self.view.backgroundColor = Colors.lightGray
        
        // Navigation Controller
        
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Tab bar controller
        
        self.tabBarController?.tabBar.isOpaque = true
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.unselectedItemTintColor = Colors.gray
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundImage = UIImage()

        
        // Character count
    
        charactersUsed = UILabel(frame: .zero)
        charactersUsed.translatesAutoresizingMaskIntoConstraints = false
        charactersUsed.textAlignment = .right
        charactersUsed.font = UIFont.systemFont(ofSize: 10)
        charactersUsed.textColor = UIColor.black
        charactersUsed.text = "0 / 2200"
        
        let countCons = [
            charactersUsed.leftAnchor.constraint(equalTo: l.centerXAnchor),
            charactersUsed.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -20),
            charactersUsed.topAnchor.constraint(equalTo: l.topAnchor, constant: 10),
            charactersUsed.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 20)
        ]
        
        self.view.addSubview(charactersUsed)
        
        NSLayoutConstraint.activate(countCons)
        
        // captionIn
        
        captionIn = UITextView(frame: .zero)
        captionIn.translatesAutoresizingMaskIntoConstraints = false
        captionIn.backgroundColor = Colors.lightGray
        captionIn.font = UIFont.systemFont(ofSize: 16)
        captionIn.textColor = UIColor.lightGray
        captionIn.text = "Start caption here..."
        
        let captionInCons = [
            captionIn.topAnchor.constraint(equalTo: l.topAnchor, constant: 20),
            captionIn.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 20),
            captionIn.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -20)
            //captionIn.bottomAnchor.constraintEqualToAnchor(l.bottomAnchor, constant: -110, id: "cib")
        ]
        
        captionInBottom = captionIn.bottomAnchor.constraint(equalTo: l.bottomAnchor, constant: -110)
        //captionInKeyboard = captionIn.bottomAnchor.constraint(equalTo: l.centerYAnchor)

        self.view.addSubview(captionIn)
        
        NSLayoutConstraint.activate(captionInCons)
        
        captionInBottom.isActive = true
        //captionInKeyboard.isActive = false
        
        // Toolbar
        
        toolbar = textEditBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.keyboardDown.addTarget(self, action: #selector(closeKeyboard), for: .touchUpInside)
        captionIn.inputAccessoryView = toolbar
        
        // Bottom plate
        
        bottomPlate = UIView(frame: .zero)
        bottomPlate.translatesAutoresizingMaskIntoConstraints = false
        bottomPlate.backgroundColor = UIColor.white
        bottomPlate.layer.cornerRadius = 30
        
        let bottomPlateCons = [
            bottomPlate.leftAnchor.constraint(equalTo: l.leftAnchor),
            bottomPlate.rightAnchor.constraint(equalTo: l.rightAnchor),
            bottomPlate.bottomAnchor.constraint(equalTo: l.bottomAnchor, constant: 30),
            bottomPlate.topAnchor.constraint(equalTo: l.bottomAnchor, constant: -90)
        ]
        
        self.view.addSubview(bottomPlate)
        
        NSLayoutConstraint.activate(bottomPlateCons)
        
        // Preview button
        
        previewButton = UIButton(frame: .zero)
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        previewButton.setImage(UIImage(systemName: "person.crop.square.fill"), for: .normal)
        previewButton.backgroundColor = UIColor.white
        previewButton.layer.cornerRadius = 15
        previewButton.layer.borderWidth = 2.5
        previewButton.layer.borderColor = Colors.lightGray.cgColor
        previewButton.clipsToBounds = true
        previewButton.tintColor = Colors.gray
        
        let previewCons = [
            previewButton.topAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 40),
            previewButton.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 40),
            previewButton.rightAnchor.constraint(equalTo: l.leftAnchor, constant: 80),
            previewButton.bottomAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 80)
        ]
        
        self.view.addSubview(previewButton)
        
        NSLayoutConstraint.activate(previewCons)
        
        // Copy button
        
        copyButton = UIButton()//(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 170, height: 50))
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        copyButton.setTitle("COPY CAPTION", for: .normal)
        copyButton.layer.cornerRadius = 15
        copyButton.tintColor = UIColor.white
        copyButton.backgroundColor = Colors.igPink
        
        let copyCons = [
            copyButton.topAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 40),
            copyButton.leftAnchor.constraint(equalTo: previewButton.rightAnchor, constant: 5),
            copyButton.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -85),
            copyButton.bottomAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 80),
        ]
        
        self.view.addSubview(copyButton)
        
        NSLayoutConstraint.activate(copyCons)
        
        // Share button
        
        shareButton = UIButton(frame: .zero)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.backgroundColor = UIColor.white
        shareButton.layer.cornerRadius = 15
        shareButton.layer.borderWidth = 2.5
        shareButton.layer.borderColor = Colors.lightGray.cgColor
        shareButton.clipsToBounds = true
        shareButton.tintColor = Colors.gray
        
        let shareCons = [
            shareButton.topAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 40),
            shareButton.leftAnchor.constraint(equalTo: copyButton.rightAnchor, constant: 5),
            shareButton.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -40),
            shareButton.bottomAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 80)
        ]
        
        self.view.addSubview(shareButton)
        
        NSLayoutConstraint.activate(shareCons)
        
        // Gradient background for copy button WIP
        /*
        
        gradient = UIView()
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.layer.cornerRadius = 10
        //gradient.backgroundColor = UIColor.blue

        let gradCons = [
            gradient.topAnchor.constraint(equalTo: captionIn.bottomAnchor),
            gradient.leftAnchor.constraint(equalTo: shareButton.rightAnchor, constant: 5),
            gradient.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -20),
            gradient.bottomAnchor.constraint(equalTo: captionIn.bottomAnchor, constant: 50),
            gradient.widthAnchor.constraint(equalTo: l.widthAnchor, constant: -170),
            gradient.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        self.view.addSubview(gradient)
        
        NSLayoutConstraint.activate(gradCons
        
        // Gradient layer
        gradLayer = CAGradientLayer()
        gradLayer.colors = [UIColor.blue, UIColor.black]//[Colors.igBlue, Colors.igBlueTwo, Colors.igPurple, Colors.igPink, Colors.igPinkTwo, Colors.igRed, Colors.igOrange, Colors.igOrangeTwo, Colors.igYellow, Colors.igYellowTwo]
        //gradLayer.locations = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        gradLayer.startPoint = CGPoint(x: 0, y: 0)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        gradLayer.frame = gradient.frame
        
        gradient.layer.insertSublayer(gradLayer, at: 0)
        */
        
        
        
        // Button targets
        
        copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareText), for: .touchUpInside)
        previewButton.addTarget(self, action: #selector(showPreview), for: .touchUpInside)
        toolbar.normal.addTarget(self, action: #selector(setNormal), for: .touchUpInside)
        toolbar.bold.addTarget(self, action: #selector(setBold), for: .touchUpInside)
        toolbar.italic.addTarget(self, action: #selector(setItalic), for: .touchUpInside)
        toolbar.clear.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        
        /*home.translatesAutoresizingMaskIntoConstraints = false
        home.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 0).isActive = true
        home.rightAnchor.constraint(equalTo: l.rightAnchor, constant: 0).isActive = true
        home.topAnchor.constraint(equalTo: l.topAnchor, constant: 0).isActive = true
        home.bottomAnchor.constraint(equalTo: l.bottomAnchor, constant: 0).isActive = true*/
    }
    
    // Show preview
    
    @objc func showPreview(_ sender: UIButton) {
        
        // Get text
        let mas = NSMutableAttributedString(attributedString: captionIn.attributedText)
        print(mas)
        
        // Setup view controller
        let pvc = previewVC()
        pvc.mas = mas
        self.present(pvc, animated: true, completion: nil)
    }
    
    // Share text
    
    @objc func shareText(_ sender: UIButton) {
        
        // Get text
        let text = captionIn.text
        
        let share = [text]
        let ac = UIActivityViewController(activityItems: share, applicationActivities: nil)
        self.present(ac, animated: true, completion: nil)
    }
    
    // Copy to clipboard
    
    @objc func copyToClipboard(_ sender: UIButton) {
        // Set the text
        UIPasteboard.general.set(attributedString: captionIn.attributedText)
        
        // Original text
        let original = sender.title(for: .normal)
        
        // Change the button text
        sender.setTitle("Copied!", for: .normal)
        
        // Change it back
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.setTitle(original, for: .normal)
        }
    }
    
    // Set normal text
    
    @objc func setNormal(_ sender: UIButton) {
        
        // Set text kind
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 16)
        ]
        
        captionIn.typingAttributes = attrs
        
        // Edit the buttons
        toolbar.bold.tintColor = Colors.gray
        toolbar.italic.tintColor = Colors.gray
        toolbar.hashtags.tintColor = Colors.gray
        toolbar.keyboardDown.tintColor = Colors.gray
        toolbar.normal.tintColor = .black
    }
    
    // Set bold text
    
    @objc func setBold(_ sender: UIButton) {
        
        // Set text kind
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.boldSystemFont(ofSize: 16)
        ]
        
        captionIn.typingAttributes = attrs
        
        // Edit the buttons
        toolbar.bold.tintColor = .black
        toolbar.italic.tintColor = Colors.gray
        toolbar.hashtags.tintColor = Colors.gray
        toolbar.keyboardDown.tintColor = Colors.gray
        toolbar.normal.tintColor = Colors.gray
        
    }
    
    // Set italic text
    
    @objc func setItalic(_ sender: UIButton) {
        
        // Set text kind
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.italicSystemFont(ofSize: 16)
        ]
        
        captionIn.typingAttributes = attrs
        
        // Edit the buttons
        toolbar.bold.tintColor = Colors.gray
        toolbar.italic.tintColor = .black
        toolbar.hashtags.tintColor = Colors.gray
        toolbar.keyboardDown.tintColor = Colors.gray
        toolbar.normal.tintColor = Colors.gray
    }
    
    @objc func clearText(_ sender: UIButton) {
        captionIn.text = ""
    }
    
    // Placeholder removal
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // Placeholder
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        // TextView Constraints
        
        captionInBottom.constant = ((self.view.frame.height / 4) * -1) - 140
        captionIn.layoutIfNeeded()
        
        
    }
    
    // Placeholder put back
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            // Set text kind
            let attrs: [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: 16)
            ]
            
            textView.typingAttributes = attrs
            textView.text = "Start caption here..."
            textView.textColor = UIColor.lightGray
        }
        
        captionInBottom.constant = -110
        UIView.animate(withDuration: 25, animations: {
            self.captionIn.layoutIfNeeded()
        })
        
    }
    
    // Character count
    
    func textViewDidChange(_ textView: UITextView) {
        let chars = textView.text.count
        charactersUsed.text = String(chars) + " / 2200"
    }
    
    // Instagram caption spacing requires a space before every new line
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.insertText(" \n")
            return false
        }
        
        return true
    }
    
    // Close the keyboard
    
    @objc func closeKeyboard(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
}

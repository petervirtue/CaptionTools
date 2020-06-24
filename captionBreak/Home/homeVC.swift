//
//  homeVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit
import Foundation
import StoreKit

class homeVC: UIViewController, UITextViewDelegate {
    
    let boldChars = ["0":"𝟬","1":"𝟭","2":"𝟮","3":"𝟯","4":"𝟰","5":"𝟱","6":"𝟲","7":"𝟳","8":"𝟴","9":"𝟵","a":"𝗮","b":"𝗯","c":"𝗰","d":"𝗱","e":"𝗲","f":"𝗳","g":"𝗴","h":"𝗵","i":"𝗶","j":"𝗷","k":"𝗸","l":"𝗹","m":"𝗺","n":"𝗻","o":"𝗼","p":"𝗽","q":"𝗾","r":"𝗿","s":"𝘀","t":"𝘁","u":"𝘂","v":"𝘃","w":"𝘄","x":"𝘅","y":"𝘆","z":"𝘇","A":"𝗔","B":"𝗕","C":"𝗖","D":"𝗗","E":"𝗘","F":"𝗙","G":"𝗚","H":"𝗛","I":"𝗜","J":"𝗝","K":"𝗞","L":"𝗟","M":"𝗠","N":"𝗡","O":"𝗢","P":"𝗣","Q":"𝗤","R":"𝗥","S":"𝗦","T":"𝗧","U":"𝗨","V":"𝗩","W":"𝗪","X":"𝗫","Y":"𝗬","Z":"𝗭"]
    
    let italicChars = ["0":"0","1":"1","2":"2","3":"3","4":"4","5":"5","6":"6","7":"7","8":"8","9":"9","a":"𝘢","b":"𝘣","c":"𝘤","d":"𝘥","e":"𝘦","f":"𝘧","g":"𝘨","h":"𝘩","i":"𝘪","j":"𝘫","k":"𝘬","l":"𝘭","m":"𝘮","n":"𝘯","o":"𝘰","p":"𝘱","q":"𝘲","r":"𝘳","s":"𝘴","t":"𝘵","u":"𝘶","v":"𝘷","w":"𝘸","x":"𝘹","y":"𝘺","z":"𝘻","A":"𝘈","B":"𝘉","C":"𝘊","D":"𝘋","E":"𝘌","F":"𝘍","G":"𝘎","H":"𝘏","I":"𝘐","J":"𝘑","K":"𝘒","L":"𝘓","M":"𝘔","N":"𝘕","O":"𝘖","P":"𝘗","Q":"𝘘","R":"𝘙","S":"𝘚","T":"𝘛","U":"𝘜","V":"𝘝","W":"𝘞","X":"𝘟","Y":"𝘠","Z":"𝘡"]
    
    // Shared instance
    
    static let sharedInstance = homeVC()
    
    // Components
    
    var captionIn: UITextView!
    var previewButton: UIButton!
    var shareButton: UIButton!
    @objc var copyButton: UIButton!
    var toolbar: textEditBar!
    var charactersUsed: UILabel!
    var charactersImage: UIImageView!
    var hashtagsUsed: UILabel!
    var hashtagsImage: UIImageView!
    var bottomPlate: UIView!
    //var gradient: UIView!
    //var gradLayer: CAGradientLayer!
    
    // Bottom constraint for Text Field
    
    var captionInBottom: NSLayoutConstraint!

    // Editing status
    
    var typingStatus = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        
        self.title = "Create"
        self.edgesForExtendedLayout = []
        
        // Run Setup
        
        setup()
        
        // Text View Delegate
        
        captionIn.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCounts(captionIn)
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
        self.navigationController?.navigationBar.tintColor = Colors.igPink
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Save Draft button
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(saveCaption))
        
        // Share Button and Previe Button
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareText)), UIBarButtonItem(image: UIImage(systemName: "person.crop.square"), style: .plain, target: self, action: #selector(showPreview))]
        
        // Tab bar controller
        
        self.tabBarController?.tabBar.isOpaque = true
        self.tabBarController?.tabBar.isTranslucent = false
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        self.tabBarController?.tabBar.tintColor = UIColor.black
        self.tabBarController?.tabBar.unselectedItemTintColor = Colors.gray
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        
        // Character Image
        
        charactersImage = UIImageView(frame: .zero)
        charactersImage.image = UIImage(systemName: "t.square")
        charactersImage.translatesAutoresizingMaskIntoConstraints = false
        charactersImage.tintColor = UIColor.black
        charactersImage.contentMode = .scaleAspectFill
        
        let countImageCons = [
            charactersImage.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 25),
            charactersImage.rightAnchor.constraint(equalTo: l.leftAnchor, constant: 35),
            charactersImage.topAnchor.constraint(equalTo: l.topAnchor, constant: 20),
            charactersImage.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 30)
        ]
        
        self.view.addSubview(charactersImage)
        
        NSLayoutConstraint.activate(countImageCons)

        
        // Character count
    
        charactersUsed = UILabel(frame: .zero)
        charactersUsed.translatesAutoresizingMaskIntoConstraints = false
        charactersUsed.textAlignment = .left
        charactersUsed.font = UIFont.systemFont(ofSize: 10)
        charactersUsed.textColor = UIColor.black
        charactersUsed.text = "0 / 2200"
        
        let countCons = [
            charactersUsed.leftAnchor.constraint(equalTo: charactersImage.rightAnchor, constant: 5),
            charactersUsed.rightAnchor.constraint(equalTo: charactersImage.rightAnchor, constant: 70),
            charactersUsed.topAnchor.constraint(equalTo: l.topAnchor, constant: 20),
            charactersUsed.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 30)
        ]
        
        self.view.addSubview(charactersUsed)
        
        NSLayoutConstraint.activate(countCons)
        
        // Hashtag Image
        
        hashtagsImage = UIImageView(frame: .zero)
        hashtagsImage.image = UIImage(systemName: "number.square")
        hashtagsImage.translatesAutoresizingMaskIntoConstraints = false
        hashtagsImage.tintColor = UIColor.black
        hashtagsImage.contentMode = .scaleAspectFill
        
        let hashtagImageCons = [
            hashtagsImage.leftAnchor.constraint(equalTo: charactersUsed.rightAnchor, constant: 5),
            hashtagsImage.rightAnchor.constraint(equalTo: charactersUsed.rightAnchor, constant: 15),
            hashtagsImage.topAnchor.constraint(equalTo: l.topAnchor, constant: 20),
            hashtagsImage.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 30)
        ]
        
        self.view.addSubview(hashtagsImage)
        
        NSLayoutConstraint.activate(hashtagImageCons)
        
        // Hashtag count
        
        hashtagsUsed = UILabel(frame: .zero)
        hashtagsUsed.translatesAutoresizingMaskIntoConstraints = false
        hashtagsUsed.textAlignment = .left
        hashtagsUsed.font = UIFont.systemFont(ofSize: 10)
        hashtagsUsed.textColor = UIColor.black
        hashtagsUsed.text = "0 / 30"
            
        let hashtagCons = [
            hashtagsUsed.leftAnchor.constraint(equalTo: hashtagsImage.rightAnchor, constant: 5),
            hashtagsUsed.rightAnchor.constraint(equalTo: l.centerXAnchor),
            hashtagsUsed.topAnchor.constraint(equalTo: l.topAnchor, constant: 20),
            hashtagsUsed.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 30)
        ]
            
        self.view.addSubview(hashtagsUsed)
            
        NSLayoutConstraint.activate(hashtagCons)
        
        // captionIn
        
        captionIn = UITextView(frame: .zero)
        captionIn.translatesAutoresizingMaskIntoConstraints = false
        captionIn.backgroundColor = Colors.lightGray
        captionIn.font = UIFont.systemFont(ofSize: 16)//UIFont(name: "Helvetica Neue", size: 16)//
        captionIn.textColor = UIColor.lightGray
        captionIn.text = "Start caption here..."
        captionIn.autocapitalizationType = .none
        
        let captionInCons = [
            captionIn.topAnchor.constraint(equalTo: l.topAnchor, constant: 30),
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
            bottomPlate.topAnchor.constraint(equalTo: l.bottomAnchor, constant: -95)
        ]
        
        self.view.addSubview(bottomPlate)
        
        NSLayoutConstraint.activate(bottomPlateCons)
        
        // Copy button
        
        copyButton = UIButton()//(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 170, height: 50))
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        copyButton.setTitle("COPY CAPTION", for: .normal)
        copyButton.layer.cornerRadius = 15
        //copyButton.layer.borderWidth = 2.5
        //copyButton.layer.borderColor = Colors.igPink!.cgColor
        copyButton.clipsToBounds = true
        copyButton.tintColor = UIColor.white
        copyButton.backgroundColor = Colors.igPink
        copyButton.setTitleColor(UIColor.white, for: .normal)
        
        let copyCons = [
            copyButton.topAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 40),
            copyButton.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 40),
            copyButton.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -40),
            copyButton.bottomAnchor.constraint(equalTo: bottomPlate.topAnchor, constant: 85)
        ]
        
        self.view.addSubview(copyButton)
        
        NSLayoutConstraint.activate(copyCons)
        
        // Button targets
        
        copyButton.addTarget(self, action: #selector(copyToClipboard), for: .touchUpInside)
        toolbar.normal.addTarget(self, action: #selector(setNormal), for: .touchUpInside)
        toolbar.bold.addTarget(self, action: #selector(setBold), for: .touchUpInside)
        toolbar.italic.addTarget(self, action: #selector(setItalic), for: .touchUpInside)
        toolbar.clear.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        toolbar.hashtags.addTarget(self, action: #selector(presentHashtags), for: .touchUpInside)
    }
    
    // Show preview
    
    @objc func showPreview(_ sender: UIButton) {
        
        // Get text
        
        let mas = NSMutableAttributedString(attributedString: captionIn.attributedText)
        
        // Setup view controller
        
        let pvc = previewVC()
        pvc.mas = mas
        
        // Feedback
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Present
        
        self.present(pvc, animated: true, completion: nil)
    }
    
    // Share text
    
    @objc func shareText(_ sender: UIButton) {
        
        // Get text
        
        let text = captionIn.text
        
        
        // Share VC
        
        let share = [text]
        let ac = UIActivityViewController(activityItems: share as [Any], applicationActivities: nil)
        
        // Feedback
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Present
        
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
        
        // Feedback
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Change it back
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            sender.setTitle(original, for: .normal)
        }
    }
    
    // Set normal text
    
    @objc func setNormal(_ sender: UIButton) {
        
        // Attributes
        
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 16)
        ]
        
        // Set selected text to normal
        
        let range = captionIn.selectedRange
        let toChange = NSMutableAttributedString(attributedString: captionIn.attributedText)
        toChange.addAttributes(attrs, range: range)
        captionIn.attributedText = toChange
        captionIn.selectedRange = range
        
        // Set text kind
        
        captionIn.typingAttributes = attrs
        typingStatus = 0
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Edit the buttons
        
        toolbar.bold.tintColor = Colors.gray
        toolbar.italic.tintColor = Colors.gray
        toolbar.normal.tintColor = .black
    }
    
    // Set bold text
    
    @objc func setBold(_ sender: UIButton) {
        
        // Set typing attributes
        
        typingStatus = 1
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Edit the buttons
        
        toolbar.bold.tintColor = .black
        toolbar.italic.tintColor = Colors.gray
        toolbar.normal.tintColor = Colors.gray
        
    }
    
    // Set italic text
    
    @objc func setItalic(_ sender: UIButton) {
        
        // Set text kind
        
        typingStatus = 2
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Edit the buttons
        toolbar.bold.tintColor = Colors.gray
        toolbar.italic.tintColor = .black
        toolbar.normal.tintColor = Colors.gray
    }
    
    @objc func clearText(_ sender: UIButton) {
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Clear text
        
        captionIn.text = ""
        updateCounts(captionIn)
    }
    
    // Placeholder removal
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        // Placeholder
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            
            // Feedback

            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
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
        updateCounts(textView)
    }
    
    // Instagram caption spacing requires a space before every new line
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.insertText(" \n")
            return false
        } else if typingStatus == 1 && boldChars.keys.contains(text) {
            textView.insertText(self.boldChars[text]!)
            return false
        } else if typingStatus == 2 && italicChars.keys.contains(text) {
            textView.insertText(italicChars[text]!)
            return false
        }
        
        return true
    }
    
    // Update toolbar status as the cursor moves NOTE - Might be too taxing so testing needs to be done
    
    
    
    // Close the keyboard
    
    @objc func closeKeyboard(_ sender: UIButton) {
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Close keyboard
        
        self.view.endEditing(true)
    }
    
    // Save caption to drafts
    
    @objc func saveCaption() {
        
        // Dont let a caption be saved if it is the placeholder text
        
        if captionIn.textColor == UIColor.lightGray {
            
            // Error VC
            
            let noCaptionAlert = UIAlertController(title: "Error", message: "You cannot save an empty caption, please enter one", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            noCaptionAlert.addAction(okay)
            
            // Feedback
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)

            // Present
            
            self.present(noCaptionAlert, animated: true, completion: nil)
            
        } else {
            
            // Ratings push
            
            let amountSaved = UserDefaults.standard.integer(forKey: "saved")
            
            UserDefaults.standard.set(amountSaved + 1, forKey: "saved")
            
            if amountSaved == 5 {
                SKStoreReviewController.requestReview()
            }
            
            // Save caption to drafts
            
            draftsVC.sharedInstance.saveCaption(captionIn.attributedText)
            
            // Send alert to the user
            
            let savedAlert = UIAlertController(title: "Caption Saved", message: "Your caption has been saved to your drafts", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            savedAlert.addAction(okay)
            
            // Feedback
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)

            
            // Present
            
            self.present(savedAlert, animated: true, completion: nil)
        }
    }
    
    // Present hashtags VC
    
    @objc func presentHashtags() {
        
        // Create VC
        
        let addHashtags = addHashtagsVC()
        
        if hashtagsVC.sharedInstance.hashtags.isEmpty {
            hashtagsVC.sharedInstance.loadData()
        }
        addHashtags.hashtags = hashtagsVC.sharedInstance.hashtags
        addHashtags.tableView.reloadData()
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Present
        
        self.present(addHashtags, animated: true, completion: nil)
    }
    
    // Add hashtags to the caption
    
    func addHashtagsToText(_ tags: [NSAttributedString]) {
        
        // Set up Mutable
        
        let combo = NSMutableAttributedString()
        let previousText = captionIn.attributedText!
        let attrs: [NSAttributedString.Key : Any] = [
            .font : UIFont.systemFont(ofSize: 16)
        ]
        combo.append(previousText)
        combo.append(NSAttributedString(string: " \n \n", attributes: attrs))
        
        for i in 1..<tags.count {
            combo.append(NSAttributedString(string: "#", attributes: attrs))
            combo.append(NSAttributedString(string: tags[i].string, attributes: attrs))
            combo.append(NSAttributedString(string: " ", attributes: attrs))
        }
        
        // Feedback
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Update caption
        
        captionIn.attributedText = combo
        
        updateCounts(captionIn)
    }
    
    // Update characters and hashtags count
    
    func updateCounts(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            charactersUsed.text = "0 / 2200"
            hashtagsUsed.text = "0 / 30"
            return
        }
        let chars = textView.text.count
        var tags = textView.text.amountOfHashtags()
        if tags != 0 {
            tags += 1
        }
        charactersUsed.text = String(chars) + " / 2200"
        hashtagsUsed.text = String(tags) + " / 30"
        
        if chars > 2200 {
            charactersUsed.textColor = .red
            charactersImage.tintColor = .red
        } else {
            charactersUsed.textColor = .black
            charactersImage.tintColor = .black
        }
        
        if tags > 30 {
            hashtagsUsed.textColor = .red
            hashtagsImage.tintColor = .red
        } else {
            hashtagsUsed.textColor = .black
            hashtagsImage.tintColor = .black
        }
    }
    
}

//
//  hashtagEditor.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/15/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit
import CoreData

class hashtagEditor: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Components
    
    var tableView: UITableView!
    var tagsTitle: UITextField!
    var tagsInput: hashtagTextField!
    var submit: UIButton!
    var close: UIButton!
    var hashtagsImage: UIImageView!
    var hashtagsUsed: UILabel!
    
    // Table view bottom constraint, to be updated for use with the keyboard
    
    var bottom: NSLayoutConstraint!
    
    // Data
    
    var hashtags: [String] = []
    var stringTitle: String = ""
    var object: NSManagedObject?
    var index = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isModalInPresentation = true

        // Setup
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tagsTitle.text!.isEmpty || hashtags.isEmpty {
            close.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else {
            close.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
        
        // Setup from object
        
        if object != nil {
            setupFromSelection()
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: true, completion: completion)
    }
    
    func setup() {
        
        // Background
        
        self.view.backgroundColor = Colors.backGray
        
        // Safe layout area
        
        let l = self.view.safeAreaLayoutGuide
        
        // Keyboard notifications
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Hashtag Image
        
        hashtagsImage = UIImageView(frame: .zero)
        hashtagsImage.image = UIImage(systemName: "number.square")
        hashtagsImage.translatesAutoresizingMaskIntoConstraints = false
        hashtagsImage.tintColor = UIColor.black
        hashtagsImage.contentMode = .scaleAspectFill
        
        let hashtagImageCons = [
            hashtagsImage.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 20),
            hashtagsImage.rightAnchor.constraint(equalTo: l.leftAnchor, constant: 30),
            hashtagsImage.topAnchor.constraint(equalTo: l.topAnchor, constant: 15),
            hashtagsImage.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 25)
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
            hashtagsUsed.topAnchor.constraint(equalTo: l.topAnchor, constant: 15),
            hashtagsUsed.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 25)
        ]
            
        self.view.addSubview(hashtagsUsed)
            
        NSLayoutConstraint.activate(hashtagCons)
        
        // Title input
        
        tagsTitle = UITextField(frame: .zero)
        tagsTitle.delegate = self
        tagsTitle.backgroundColor = Colors.backGray
        tagsTitle.translatesAutoresizingMaskIntoConstraints = false
        tagsTitle.font = UIFont.boldSystemFont(ofSize: 25)
        tagsTitle.textColor = UIColor.black
        let placeholderatts = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        tagsTitle.attributedPlaceholder = NSAttributedString(string: "Title goes here", attributes: placeholderatts)
        
        let tagsTitleCons = [
            tagsTitle.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 20),
            tagsTitle.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -65),
            tagsTitle.topAnchor.constraint(equalTo: l.topAnchor, constant: 25),
            tagsTitle.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 65)
        ]
        
        self.view.addSubview(tagsTitle)
        
        NSLayoutConstraint.activate(tagsTitleCons)
        
        // Close button
        
        close = UIButton(frame: .zero)
        close.translatesAutoresizingMaskIntoConstraints = false
        close.setImage(UIImage(systemName: "checkmark"), for: .normal)
        close.backgroundColor = Colors.backGray
        close.tintColor = Colors.igPink
        
        let closeCons = [
            close.leftAnchor.constraint(equalTo: tagsTitle.rightAnchor, constant: 5),
            close.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -20),
            close.topAnchor.constraint(equalTo: l.topAnchor, constant: 25),
            close.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 65)
        ]
        
        
        // Work in here, start to transition the cells over to a combined look
        
        self.view.addSubview(close)
        
        NSLayoutConstraint.activate(closeCons)
        
        // Table view
        
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = Colors.backGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewCons = [
            tableView.leftAnchor.constraint(equalTo: l.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: l.rightAnchor),
            tableView.topAnchor.constraint(equalTo: tagsTitle.bottomAnchor, constant: 10)
        ]
        
        bottom = tableView.bottomAnchor.constraint(equalTo: l.bottomAnchor, constant: -70)
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate(tableViewCons)
        NSLayoutConstraint.activate([bottom])
        
        // Table view setup
        
        tableView.register(editorCell.self, forCellReuseIdentifier: "editorCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        // Hashtag input
        
        tagsInput = hashtagTextField(frame: .zero)
        tagsInput.delegate = self
        tagsInput.backgroundColor = UIColor.white
        tagsInput.translatesAutoresizingMaskIntoConstraints = false
        tagsInput.font = UIFont.systemFont(ofSize: 16)
        tagsInput.autocorrectionType = .no
        tagsInput.textColor = UIColor.black
        tagsInput.layer.cornerRadius = 20
        //tagsInput.layer.borderWidth = 2.5
        //tagsInput.layer.borderColor = Colors.lightGray.cgColor
        tagsInput.attributedPlaceholder = NSAttributedString(string: "Hashtag goes here", attributes: placeholderatts)
        
        let tagsInputCons = [
            tagsInput.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 16),
            tagsInput.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -16),
            tagsInput.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            tagsInput.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50)
        ]
        
        self.view.addSubview(tagsInput)
        
        NSLayoutConstraint.activate(tagsInputCons)
        
        // Submit button
        
        submit = UIButton(frame: .zero)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        submit.tintColor = UIColor.white
        submit.backgroundColor = Colors.igPink
        submit.layer.cornerRadius = 15
        
        let submitCons = [
            submit.leftAnchor.constraint(equalTo: l.rightAnchor, constant: -51),//-53.5),
            submit.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -21),//-18.5),
            submit.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
            submit.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 45)
        ]
        
        self.view.addSubview(submit)
        
        NSLayoutConstraint.activate(submitCons)
        
        // Targets
        
        submit.addTarget(self, action: #selector(addHashtag), for: .touchUpInside)
        close.addTarget(self, action: #selector(saveHashtags), for: .touchUpInside)
        
        
        
    }
    
    func setupFromSelection() {
        
        let data = object!.value(forKey: "hashtags") as? NSData
        
        do {
            let hashtag = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(referencing: data!)) as! HashtagObject
            let tags = hashtag.attributedStrings
            
            for i in 0..<tags.count {
                if i == 0 {
                    stringTitle = tags[i].string
                }
                else {
                    hashtags.append(tags[i].string)
                }
            }
            
            tagsTitle.text = stringTitle
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Error loading pre made hashtags. \n \(error)")
        }
        
        
        // Update close
        
        updateClose()
        
        updateTagsCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hashtags.count == 0 {
            tableView.setEmptyView(title: "No saved hashtags", sub: "Your hashtags will be in here")
        } else {
            tableView.restoreFromEmpty()
        }
        
        return hashtags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "editorCell") as! editorCell
        
        cell.hashtagLabel.text = "   #" + hashtags[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Deletion style
        
        if editingStyle == .delete {
            
            // Feedback
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Get the specific caption
            
            hashtags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        updateTagsCount()
        
        updateClose()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == tagsTitle {
            
            // Update close
            
            updateClose()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tagsTitle {
            if textField.text!.isEmpty || hashtags.isEmpty {
                close.setImage(UIImage(systemName: "xmark"), for: .normal)
            } else {
                close.setImage(UIImage(systemName: "checkmark"), for: .normal)
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tagsTitle {
            self.view.endEditing(true)
        } else if textField == tagsInput {
            if tagsInput.text!.isEmpty {
                self.view.endEditing(true)
            } else {
                addHashtagManual()
            }
        }
        
        return false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var iphoneX = false
        if UIScreen.main.bounds.height / UIScreen.main.bounds.width > 2.1 && UIScreen.main.bounds.height / UIScreen.main.bounds.width < 2.2 {//812.0 / 375.0 {
            iphoneX = true
        }
        
        if iphoneX {
            bottom.constant = -1 * keyboardSize.height - 25
        } else {
            bottom.constant = -1 * keyboardSize.height - 60
        }
        
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(notificaton: NSNotification) {
        
        bottom.constant = -70
        
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func addHashtag(_ sender: UIButton) {
    
        if !tagsInput.text!.isEmpty {
            
            // Feedback

            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            // Add the hashtag
            
            let hashtag = tagsInput.text!
            hashtags.append(hashtag)
            tagsInput.text = ""
            tableView.reloadData()
        
            // Update close
            
            updateClose()
        }
        
        updateTagsCount()
        
    }
    
    func addHashtagManual() {
        if !tagsInput.text!.isEmpty {
            
            // Feedback

            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            
            // Add the hashtag
            
            let hashtag = tagsInput.text!
            hashtags.append(hashtag)
            tagsInput.text = ""
            tableView.reloadData()
        
            // Update close
            
            updateClose()
        }
        
        updateTagsCount()
    }
    
    @objc func saveHashtags() {
        
        if hashtags.count > 30 {
            
            // Feedback
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
            // Send alert to the user
            
            let tooMany = UIAlertController(title: "Error", message: "You have more than 30 captions saved, please cut your list down to 30 or below", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            tooMany.addAction(okay)
            self.present(tooMany, animated: true, completion: nil)
            
        } else {

            // If it is a new group or a pre-existing one
            
            if index == -1 {
                if tagsTitle.text!.isEmpty || hashtags.isEmpty {
                    
                    // Feedback
                    
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    // Dismiss
                    
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    
                    // Create tags
                    
                    var tags: [NSAttributedString] = []
                    let t = NSAttributedString(string: tagsTitle.text!)
                    tags.append(t)
                    for s in hashtags {
                        let temp = NSAttributedString(string: s)
                        tags.append(temp)
                    }
                    
                    // Save tags
                    
                    hashtagsVC.sharedInstance.saveHashtags(tags)
                    
                    // Feedback
                    
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Dismiss
                    
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                
                // Feedback
                
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                if tagsTitle.text!.isEmpty || hashtags.isEmpty {
                    
                    // Create alert and actions
                    
                    let tooLittle = UIAlertController(title: "Warning", message: "You have no hashtags saved in this group and it will delete, would you like to cancel this action?", preferredStyle: .alert)
                    tooLittle.modalPresentationStyle = .popover
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        // Feedback
                        
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    })
                    let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                        
                        // Remove the tags if delete is selected
                        
                        self.removeTagsFromHome(at: self.index)
                        
                        // Feedback
                        
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                    })
                    
                    // Add actions
                    
                    tooLittle.addAction(cancel)
                    tooLittle.addAction(delete)
                    
                    // Present alert
                    
                    self.present(tooLittle, animated: true, completion: {})
                    
                } else {
                    
                    // Remove original tags
                    
                    removeTagsFromHome(at: index)
                    
                    // Create new tags
                    
                    var tags: [NSAttributedString] = []
                    let t = NSAttributedString(string: tagsTitle.text!)
                    tags.append(t)
                    for s in hashtags {
                        let temp = NSAttributedString(string: s)
                        tags.append(temp)
                    }
                    
                    // Save tags
                    
                    hashtagsVC.sharedInstance.saveHashtagsToIndex(tags: tags, index: index)
                    
                    // Present
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateTagsCount() {
        hashtagsUsed.text = String(hashtags.count) + " / 30"
        
        if hashtags.count > 30 {
            hashtagsUsed.textColor = .red
            hashtagsImage.tintColor = .red
        } else {
            hashtagsUsed.textColor = .black
            hashtagsImage.tintColor = .black
        }
    }
    
    func updateClose() {
        if tagsTitle.text!.isEmpty || hashtags.isEmpty {
            close.setImage(UIImage(systemName: "xmark"), for: .normal)
        } else {
            close.setImage(UIImage(systemName: "checkmark"), for: .normal)
        }
    }
    
    func removeTagsFromHome(at: Int) {
        
        let toRemove = hashtagsVC.sharedInstance.hashtags[at]
        hashtagsVC.sharedInstance.deleteHashtag(at: IndexPath(row: at, section: 0))
        hashtagsVC.sharedInstance.removeHashtags(toRemove)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

//
//  hashtagsVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/11/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit
import CoreData

class HashtagsController: UITableViewController {
    
    // Shared instance
    
    static let sharedInstance = HashtagsController()
    
    // Components
    
    // Hashtags
    
    var hashtags: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        
        self.title = "Hashtags"
        self.edgesForExtendedLayout = [.top]
        
        // Tab bar controller

        if let tbc = self.tabBarController {
            if let items = tbc.tabBar.items
            {
                for item in items {
                    item.title = ""
                }
            }
        }
        
        // Table view setup
        
        self.tableView.register(HashtagTableCell.self, forCellReuseIdentifier: "hashtagCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // Setup
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load data
        loadData()
    }
    
    func setup() {
        
        // Background
        
        self.view.backgroundColor = UIColor.init(named: "background")!
        
        // Table view styling
        
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        // Hiding the hairline
        
        self.navigationController?.hideHairline()
        
        // Add and Editing button
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(openHashtagEditor))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(setTVEditing))
    
        
    }
    
    // Table view deletion
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Deletion style
        
        if editingStyle == .delete {
            
            // Feedback
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Delete the hashtag
            
            deleteHashtag(at: indexPath)
            
        }
    }
    
    // Table view is empty or not
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hashtags.count == 0 {
            tableView.setEmptyView(title: "No saved hashtags", sub: "Your hashtags will be in here")
        } else {
            tableView.restoreFromEmpty()
        }
        
        return hashtags.count
    }
    
    // Table view height
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // Table view cell creation
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashtagCell") as! HashtagTableCell

        // Getting data
        let data = hashtags[indexPath.row].value(forKey: "hashtags") as? NSData

        // Transitioning the data to the cell
        do {
            let hashtag = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(referencing: data!)) as! HashtagItem
            let tags = hashtag.attributedStrings
            let tagsMutable = NSMutableAttributedString()
            let attrs: [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: 16)
            ]
            for i in 0..<tags.count {
                let nsa = NSAttributedString(string: tags[i].string, attributes: attrs)
                if i == 0 {
                    cell.label.attributedText = tags[i]
                } else if i == tags.count - 1 {
                    tagsMutable.append(NSAttributedString(string: "#", attributes: attrs))
                    tagsMutable.append(nsa)
                } else {
                    tagsMutable.append(NSAttributedString(string: "#", attributes: attrs))
                    tagsMutable.append(nsa)
                    tagsMutable.append(NSAttributedString(string: ", ", attributes: attrs))
                }
            }
            
            cell.textView.attributedText = tagsMutable
            cell.textView.textColor = UIColor.init(named: "textColor")!
            
        } catch let error as NSError {
            print("Error loading content into the cells. \n \(error)")
        }
        
        // Corner rounding for first and last object
        
        cell.backPlate.layer.cornerRadius = 0
        cell.backPlate.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        if (hashtags.count == 1) {
            
            // Round all corners as the item is the only one in the array
            
            cell.backPlate.layer.cornerRadius = 10
            
            // Remove seperator
            
            cell.seperator.removeFromSuperview()
            
        } else if (indexPath.row == 0) {
            
            // Round top corners
            
            cell.backPlate.layer.cornerRadius = 10
            cell.backPlate.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            
            // Remove seperator
            
            cell.seperator.removeFromSuperview()
            
        } else if (indexPath.row == hashtags.count - 1) {
            
            // ROund bottom corners
            
            cell.backPlate.layer.cornerRadius = 10
            cell.backPlate.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        return cell
    }
    
    // Cell selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Send caption to the editor
        
        sendHashtagsToEditor(index: indexPath.row)
    }
    
    // Set the TableView as editing
    
    @objc func setTVEditing() {
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    // Send already created group to editor
    
    func sendHashtagsToEditor(index: Int) {
        
        let editor = HashtagEditorController()
        editor.object = hashtags[index]
        editor.index = index
        present(editor, animated: true, completion: nil)
    }
    
    // Save hashtags
    
    func saveHashtags(_ tags: [NSAttributedString]) {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Entity cretion
        
        let entity = NSEntityDescription.entity(forEntityName: "Hashtag", in: managedContext)!
        
        // hashtag as NSManagedObject creation
        
        let hashtag = NSManagedObject(entity: entity, insertInto: managedContext)
        let tagObject = HashtagItem(attributedStrings: tags)
        do {
            let data: NSData = NSData(data: try NSKeyedArchiver.archivedData(withRootObject: tagObject, requiringSecureCoding: false))
            hashtag.setValue(data, forKey: "hashtags")
            
            do {
                try managedContext.save()
                hashtags.append(hashtag)
                tableView.reloadData()
            } catch let error as NSError {
                print("Could not save data. \n\(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Error converting Hashtag object to data.\n\(error), \(error.userInfo)")
        }
        
    }
    
    // Save hashtags to a specific index
    
    func saveHashtagsToIndex(tags: [NSAttributedString], index: Int) {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Entity cretion
        
        let entity = NSEntityDescription.entity(forEntityName: "Hashtag", in: managedContext)!
        
        // hashtag as NSManagedObject creation
        
        let hashtag = NSManagedObject(entity: entity, insertInto: managedContext)
        let tagObject = HashtagItem(attributedStrings: tags)
        do {
            let data: NSData = NSData(data: try NSKeyedArchiver.archivedData(withRootObject: tagObject, requiringSecureCoding: false))
            hashtag.setValue(data, forKey: "hashtags")
            
            do {
                try managedContext.save()
                hashtags.insert(hashtag, at: index)
                tableView.reloadData()
            } catch let error as NSError {
                print("Could not save data. \n\(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Error converting Hashtag object to data.\n\(error), \(error.userInfo)")
        }
    }
    
    // Remove hashtags
    
    func removeHashtags(_ hashtag: NSManagedObject) {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Try action
        
        do {
            managedContext.delete(hashtag)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save data after deletion. \(error), \(error.userInfo)")
        }
    }
    
    // Load hashtags
    
    func loadData() {
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Fetch request creation
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Hashtag")
        
        // Try action
        
        do {
            hashtags = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Error, could not save data. \n\(error), \(error.userInfo)")
        }
    }
    
    // Open the editor to create a new group
    
    @objc func openHashtagEditor() {
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Present View controller
        
        let he = HashtagEditorController()
        self.present(he, animated: true, completion: nil)
    }
    
    // Delete hashtag from vc
    
    func deleteHashtag(at: IndexPath) {
        
        // Get hashtag
        
        let hashtag = hashtags[at.row]
        
        // Remove the caption from the captions array, Core Data, and the TableView
        
        hashtags.remove(at: at.row)
        self.tableView.deleteRows(at: [at], with: .fade)
        removeHashtags(hashtag)
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
            return self.makeDeleteMenuFor(indexPath)
        })
    }
    
    func makeDeleteMenuFor(_ indexPath: IndexPath) -> UIMenu {
        
        let deleteConfirm = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.deleteHashtag(at: indexPath)
        }
        let cancel = UIAction(title: "Cancel", image: UIImage(systemName: "xmark")) { action in }
        
        let delete = UIMenu(title: "Delete", image: UIImage(systemName: "trash"), options: .destructive, children: [cancel, deleteConfirm])
        
        return UIMenu(title: "", children: [delete])
    }

}

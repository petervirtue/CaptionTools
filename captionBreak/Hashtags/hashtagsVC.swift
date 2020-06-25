//
//  hashtagsVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/11/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit
import CoreData

class hashtagsVC: UITableViewController {
    
    // Shared instance
    
    static let sharedInstance = hashtagsVC()
    
    // Components
    
    // Hashtags
    
    var hashtags: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        
        self.title = "Hashtags"
        self.edgesForExtendedLayout = []
        
        // Table view setup
        
        self.tableView.register(hashtagCell.self, forCellReuseIdentifier: "hashtagCell")
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
        
        self.view.backgroundColor = Colors.backGray
        
        // Table view styling
        
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        
        // Navigation Controller
        /*
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = Colors.igPink
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        */
        // Cosmetic changes for a future update
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = Colors.backGray
        appearance.shadowImage = UIImage()
        appearance.backgroundImage = UIImage()
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = Colors.backGray
        self.navigationController?.navigationBar.tintColor = Colors.igPink
        self.navigationController?.hideHairline()
        
        // Add and Editing button
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: #selector(openHashtagEditor))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(setTVEditing))
    
        
    }
    
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hashtags.count == 0 {
            tableView.setEmptyView(title: "No saved hashtags", sub: "Your hashtags will be in here")
        } else {
            tableView.restoreFromEmpty()
        }
        
        return hashtags.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create the cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashtagCell") as! hashtagCell
        
        // Getting data
        
        let data = hashtags[indexPath.row].value(forKey: "hashtags") as? NSData
        
        // Transitioning the data to the cell
        
        do {
            let hashtag = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(referencing: data!)) as! HashtagObject
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
            
            // Corner rounding for first and last object
            
            cell.backPlate.layer.cornerRadius = 0
            
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
            
        } catch let error as NSError {
            print("Error loading content into the cells. \n \(error)")
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
        
        let editor = hashtagEditor()
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
        let tagObject = HashtagObject(attributedStrings: tags)
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
        let tagObject = HashtagObject(attributedStrings: tags)
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
            //loadData()
            //tableView.reloadData()
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
        
        let he = hashtagEditor()
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
        
    }

}

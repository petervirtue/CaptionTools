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
    var tags: [[NSAttributedString]] = []
    
    // Testing
    
    var testing = ["Testing", "hashtagone", "hashtagtwo", "hashtagthree", "hashtagfour", "hashtagfive", "hashtagsix"]

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
    
    func setup() {
        
        // Background
        
        self.view.backgroundColor = Colors.lightGray
        
        // Table view styling
        
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        // Navigation Controller
        
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = Colors.igPink
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Add and Editing button
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.square"), style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(setTVEditing))
        
        // Setup
        
        createTestHashtags()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create the cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashtagCell") as! hashtagCell
        
        // Get the information from Core Data
        
        for i in 0..<testing.count {
            if i == 0 {
                //cell.label.text = testing[i]
            } else if i == testing.count - 1 {
                //cell.textView.text.append("#" + testing[i])
            } else {
                //cell.textView.text.append("#" + testing[i] + ", ")
            }
        }
        
        for group in tags {
            let tagsMutable = NSMutableAttributedString()
            for i in 0..<group.count {
                if i == 0 {
                    cell.label.attributedText = group[i]
                } else if i == testing.count - 1 {
                    tagsMutable.append(NSAttributedString(string: "#"))
                    tagsMutable.append(group[i])
                    tagsMutable.append(NSAttributedString(string: ", "))
                } else {
                    tagsMutable.append(NSAttributedString(string: "#"))
                    tagsMutable.append(group[i])
                }
            }
            cell.textView.attributedText = tagsMutable
        }
        
        return cell
    }
    
    // Set the TableView as editing
    
    @objc func setTVEditing() {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
    }
    
    func createHashtag() {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Fetch request creation
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Caption")
        
        // Try action
        
    }
    
    func loadHashtags() {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Fetch request creation
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HashtagGroup")
        
        // Try action
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            var i = 0
            var j = 0
            for data in result {
                let ht = data.value(forKey: "hashtag") as! Hashtags
                print("hashtag batch: \(i)")
                for element in ht.hashtags {
                    print("hashtag \(j): " + element.string)
                    tags[i][j] = element
                    j += 1
                }
                i += 1
            }
            
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not load data. \(error), \(error.userInfo)")
        }
    }
    
    func createTestHashtags() {
        
        // Create appDelegate and managedContext
               
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Entity creation
        
        let entity = NSEntityDescription.entity(forEntityName: "HashtagGroup", in: managedContext)!
        
        var nstrings: [NSAttributedString] = []
        
        for s in testing {
            let temp = NSAttributedString(string: s)
            nstrings.append(temp)
        }
        
        let hg = NSManagedObject(entity: entity, insertInto: managedContext)
        let hastags = Hashtags(hashtags: nstrings)
        hg.setValue(hastags, forKey: "tags")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save data. \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    

}

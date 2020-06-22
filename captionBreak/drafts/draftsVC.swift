//
//  draftsVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/11/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit
import CoreData

class draftsVC: UITableViewController {
    
    // Shared instance
    
    static let sharedInstance = draftsVC()
    
    // Saved captions
    
    var captions: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Controller setup
        
        self.title = "Drafts"
        self.edgesForExtendedLayout = []
        
        // Table View
        
        self.tableView.register(draftCell.self, forCellReuseIdentifier: "draftCell")
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
        
        self.view.backgroundColor = Colors.lightGray
        
        // Table view styling
        
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        // Navigation Controller
        
        self.navigationController?.navigationBar.isOpaque = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = Colors.igPink
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // Settings and Editing button
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(openSettings))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(setTVEditing))
        
    }
    
    // Cell Height
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    // Creating each cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create the cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "draftCell") as! draftCell
        
        // Get the information from Core Data
        
        let data = captions[indexPath.row].value(forKey: "attributedText") as? NSData
        let t = data!.toAttributedString()
        
        // Set data and return
        
        cell.textView.attributedText = t
        cell.label.text = String(indexPath.row + 1)
        
        return cell
    }
    
    // Cell deletion
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Deletion style
        
        if editingStyle == .delete {
            
            // Get the specific caption
            
            let caption = captions[indexPath.row]
            
            // Feedback
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Remove the caption from the captions array, Core Data, and the TableView
            
            captions.remove(at: indexPath.row)
            removeCaption(caption)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Cell selection
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Send caption to the editor
        
        sendCaptionToEditor(captions[indexPath.row])
    }
    
    // Number of cells
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Empty view handling
        
        if captions.count == 0 {
            tableView.setEmptyView(title: "No saved captions", sub: "Your captions will be in here")
        } else {
            tableView.restoreFromEmpty()
        }
        
        return captions.count
    }
    
    // Save a caption to Core Data
    
    func saveCaption(_ c: NSAttributedString) {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Caption to data
        
        let entity = NSEntityDescription.entity(forEntityName: "Caption", in: managedContext)!
        let caption = NSManagedObject(entity: entity, insertInto: managedContext)
        caption.setValue(c.toNSData(), forKey: "attributedText")
        
        // Try action
        
        do {
            try managedContext.save()
            captions.append(caption)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not save data. \(error), \(error.userInfo)") 
        }
    }
    
    // Remove caption from Core Data
    
    func removeCaption(_ caption: NSManagedObject) {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Try action
        
        do {
            managedContext.delete(caption)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save data after deletion. \(error), \(error.userInfo)")
        }
        
    }
    
    // Load data from Core Data
    
    func loadData() {
        
        // Create appDelegate and managedContext
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Fetch request creation
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Caption")
        
        // Try action
        
        do {
            captions = try managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not save data. \(error), \(error.userInfo)")
        }
    }
    
    func sendToEditor(_ s: NSAttributedString) {
        
        // set the text in the editor
        
        homeVC.sharedInstance.captionIn.attributedText = s
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Send to that view controller
        
        self.tabBarController?.selectedIndex = 1
    }
    
    func sendCaptionToEditor(_ caption: NSManagedObject) {
        
        // Get the attributed string
        
        let d = caption.value(forKey: "attributedText") as? NSData
        let s = d?.toAttributedString()
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Send to the home view controller
        
        homeVC.sharedInstance.captionIn.attributedText = s
        homeVC.sharedInstance.updateCounts(homeVC.sharedInstance.captionIn)
        
        // Go to the VC
        
        self.tabBarController?.selectedIndex = 1
        
    }
    
    // Set the TableView as editing
    
    @objc func setTVEditing() {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    // Open settings
    
    @objc func openSettings() {
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        // Create and present vc
        
        let settings = settingsVC()
        present(settings, animated: true, completion: nil)
    }

}

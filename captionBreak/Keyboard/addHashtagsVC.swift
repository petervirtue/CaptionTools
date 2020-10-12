//
//  addHashtagsVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/17/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit
import CoreData

class addHashtagsVC: UITableViewController {
    
    var hashtags: [NSManagedObject] = []
    
    var dragbar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Table view setup
        self.tableView.register(hashtagCell.self, forCellReuseIdentifier: "hashtagCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.backgroundColor = UIColor.init(named: "background2")!
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 20, right: 0)
        
        // Drag bar
        
        dragbar = UIView(frame: .zero)
        dragbar.backgroundColor = UIColor.systemGray3
        dragbar.layer.cornerRadius = 2.5
        dragbar.translatesAutoresizingMaskIntoConstraints = false
        
        let l = self.view.safeAreaLayoutGuide
        
        let dragbarCons = [
            dragbar.leftAnchor.constraint(equalTo: l.centerXAnchor, constant: -20),
            dragbar.rightAnchor.constraint(equalTo: l.centerXAnchor, constant: 20),
            dragbar.topAnchor.constraint(equalTo: l.topAnchor, constant: 10),
            dragbar.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 15)
        ]
        
        self.view.addSubview(dragbar)
        
        NSLayoutConstraint.activate(dragbarCons)
        
        
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
        return 130
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
            cell.textView.textColor = UIColor.init(named: "textColor")!
            
        } catch let error as NSError {
            print("Error loading content into the cells. \n \(error)")
        }
        
        // Background edit
        
        cell.backPlate.backgroundColor = UIColor.init(named: "element2")!
        cell.label.backgroundColor = UIColor.init(named: "element2")!
        cell.textView.backgroundColor = UIColor.init(named: "element2")!
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Getting data
        
        let data = hashtags[indexPath.row].value(forKey: "hashtags") as? NSData
        
        // Transitioning the data to the cell
        
        do {
            let hashtag = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(referencing: data!)) as! HashtagObject
            let tags = hashtag.attributedStrings
            homeVC.sharedInstance.addHashtagsToText(tags)
            self.dismiss(animated: true, completion: nil)
            
        } catch let error as NSError {
            print("Error loading content into the the homeVC. \n \(error)")
        }
        
        
    }

}

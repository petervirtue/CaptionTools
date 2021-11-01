//
//  NewHashtagsController.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/17/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit
import CoreData

class NewHashtagsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var hashtags: [NSManagedObject] = []
    var tableView: UITableView!
    var close: UIButton!
    var tagsTitle: UILabel!

    override func viewDidLoad() {

        // View did load

        super.viewDidLoad()
        
        // Modal Presentation
        
        self.isModalInPresentation = true
        
        // Setup
        
        setup()
        
    }
    
    func setup() {

        // Safe Layout
        
        let l = self.view.safeAreaLayoutGuide
        
        // Background
        
        self.view.backgroundColor = UIColor.init(named: "background2")!
        
        // Title input
        
        tagsTitle = UILabel(frame: .zero)
        tagsTitle.text = "Hashtag Groups"
        tagsTitle.backgroundColor = UIColor.init(named: "background2")!
        tagsTitle.translatesAutoresizingMaskIntoConstraints = false
        tagsTitle.font = UIFont(name: "Montserrat-Bold", size: 25)//UIFont.boldSystemFont(ofSize: 25)
        tagsTitle.textColor = UIColor.init(named: "textColor")!

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
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.backgroundColor = UIColor.init(named: "background2")!
        close.tintColor = UIColor.init(named: "pink")!
        
        let closeCons = [
            close.leftAnchor.constraint(equalTo: tagsTitle.rightAnchor, constant: 5),
            close.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -20),
            close.topAnchor.constraint(equalTo: l.topAnchor, constant: 25),
            close.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 65)
        ]
        
        self.view.addSubview(close)
        
        NSLayoutConstraint.activate(closeCons)
        
        // Table view

        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = UIColor.init(named: "background2")!
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewCons = [
            tableView.leftAnchor.constraint(equalTo: l.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: l.rightAnchor),
            tableView.topAnchor.constraint(equalTo: tagsTitle.bottomAnchor, constant: 10)
        ]
        
        let bottom = tableView.bottomAnchor.constraint(equalTo: l.bottomAnchor, constant: -70)
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate(tableViewCons)
        NSLayoutConstraint.activate([bottom])
        
        // Table view setup
        
        tableView.register(HashtagTableCell.self, forCellReuseIdentifier: "hashtagCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        // Buttons
        close.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hashtags.count == 0 {
            tableView.setEmptyView(title: "No saved hashtags", sub: "Your hashtags will be in here")
        } else {
            tableView.restoreFromEmpty()
        }
        
        return hashtags.count
    }
    
    @objc func closeScreen() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            
            // Round bottom corners
            cell.backPlate.layer.cornerRadius = 10
            cell.backPlate.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Getting data
        let data = hashtags[indexPath.row].value(forKey: "hashtags") as? NSData
        
        // Transitioning the data to the cell
        do {
            let hashtag = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(referencing: data!)) as! HashtagItem
            let tags = hashtag.attributedStrings
            HomeController.sharedInstance.addHashtagsToText(tags)
            self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print("Error loading content into the the homeVC. \n \(error)")
        }
    }
}

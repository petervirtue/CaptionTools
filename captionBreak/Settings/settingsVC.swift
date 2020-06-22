//
//  settingsVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/19/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class settingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Settings options
    
    var options = ["Review the App", "Share the App", "Contact the Developer", "Privacy Policy"]
    
    // Components
    
    var tableView: UITableView!
    var dragbar: UIView!
    var titleLabel: UILabel!
    var developerLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Safe area
        
        let l = self.view.safeAreaLayoutGuide
        
        // Background
        
        self.view.backgroundColor = .white
        
        // Drag bar
        
        dragbar = UIView(frame: .zero)
        dragbar.backgroundColor = UIColor.gray
        dragbar.layer.cornerRadius = 2.5
        dragbar.translatesAutoresizingMaskIntoConstraints = false
        
        let dragbarCons = [
            dragbar.leftAnchor.constraint(equalTo: l.centerXAnchor, constant: -50),
            dragbar.rightAnchor.constraint(equalTo: l.centerXAnchor, constant: 50),
            dragbar.topAnchor.constraint(equalTo: l.topAnchor, constant: 10),
            dragbar.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 15)
        ]
        
        self.view.addSubview(dragbar)
        
        NSLayoutConstraint.activate(dragbarCons)
        
        // Title label
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Settings"
        
        let titleCons = [
            titleLabel.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: l.rightAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: l.topAnchor, constant: 30),
            titleLabel.bottomAnchor.constraint(equalTo: l.topAnchor, constant: 80)
        ]
        
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate(titleCons)
        
        // Table view
        
        tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white//Colors.lightGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        let tableViewCons = [
            tableView.leftAnchor.constraint(equalTo: l.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: l.rightAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: l.bottomAnchor, constant: -20)//50)
        ]
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate(tableViewCons)
        
        // Developer label
        
        developerLabel = UILabel(frame: .zero)
        developerLabel.text = "© 2020 Peter Virtue, All Rights Reserved"
        developerLabel.textAlignment = .center
        developerLabel.font = UIFont.systemFont(ofSize: 12)
        developerLabel.textColor = .gray
        developerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let devCons = [
            developerLabel.leftAnchor.constraint(equalTo: l.leftAnchor),
            developerLabel.rightAnchor.constraint(equalTo: l.rightAnchor),
            developerLabel.bottomAnchor.constraint(equalTo: l.bottomAnchor),
            developerLabel.topAnchor.constraint(equalTo: l.bottomAnchor, constant: -20)
        ]
        
        self.view.addSubview(developerLabel)
        
        NSLayoutConstraint.activate(devCons)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return options.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = options[indexPath.row]
        //cell.accessoryType = .disclosureIndicator
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = .gray
        cell.accessoryView = chevron
        cell.imageView?.tintColor = Colors.igPink
        cell.tintColor = .gray
        cell.selectionStyle = .none
        
        if options[indexPath.row] == "Review the App" {
            cell.imageView?.image = UIImage(systemName: "star")
        } else if options[indexPath.row] == "Share the App" {
            cell.imageView?.image = UIImage(systemName: "arrowshape.turn.up.left")
        } else if options[indexPath.row] == "Contact the Developer" {
            cell.imageView?.image = UIImage(systemName: "envelope")
        } else if options[indexPath.row] == "Privacy Policy" {
            cell.imageView?.image = UIImage(systemName: "hand.raised")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = Colors.lightGray
        
        // Feedback

        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if options[indexPath.row] == "Review the App" {
            rateApp()
        } else if options[indexPath.row] == "Share the App" {
            shareApp()
        } else if options[indexPath.row] == "Contact the Developer" {
            contactDev()
        } else if options[indexPath.row] == "Privacy Policy" {
            openPrivacyPolicy()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // Let users rate the app
    
    func rateApp() {
        SKStoreReviewController.requestReview()
    }
    
    // Let users share the app
    
    func shareApp() {
        
        if let urlStr = NSURL(string: "https://itunes.apple.com/us/app/myapp/1518247106?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }

            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // Let users check the privacy policy
    
    func openPrivacyPolicy() {
        
        if let url = URL(string: "https://petervirtue.com/privacy/captiontools/") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let sfvc = SFSafariViewController(url: url, configuration: config)
            present(sfvc, animated: true, completion: nil)
        }
    }
    
    // Let users email me
    
    func contactDev() {
        
        if let url = URL(string: "mailto:petervirtue18@gmail.com") {
            UIApplication.shared.open(url)
        }
        
    }
    
    

}

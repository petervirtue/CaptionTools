//
//  settingsVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/19/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit
import StoreKit
import SafariServices

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    // Components
    var card: UIView!
    var dismissBar: UIView!
    var tableView: UITableView!
    var developerLabel: UILabel!
    
    // Settings options
    var options = ["Review the App", "Share the App", "Contact the Developer", "Privacy Policy"]
    
    // Constraints
    var cardTopCon = NSLayoutConstraint()
    var panStart: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCard()
    }
    
    func setup() {
        let l = view.safeAreaLayoutGuide
        
        // Card
        card = UIView(frame: .zero)
        card.backgroundColor = UIColor.init(named: "element2")
        card.clipsToBounds = true
        card.layer.cornerRadius = 10
        card.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        card.translatesAutoresizingMaskIntoConstraints = false
        
        let cCons = [
            card.leftAnchor.constraint(equalTo: l.leftAnchor),
            card.rightAnchor.constraint(equalTo: l.rightAnchor),
            card.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        cardTopCon = card.topAnchor.constraint(equalTo: self.view.topAnchor, constant: view.frame.height)
        
        self.view.addSubview(card)
        NSLayoutConstraint.activate(cCons)
        NSLayoutConstraint.activate([cardTopCon])
        
        // Dismiss bar
        dismissBar = UIView(frame: .zero)
        dismissBar.backgroundColor = UIColor.systemGray3
        dismissBar.translatesAutoresizingMaskIntoConstraints = false
        dismissBar.clipsToBounds = true
        dismissBar.layer.cornerRadius = 2.5
        
        let dbCons = [
            dismissBar.leftAnchor.constraint(equalTo: l.centerXAnchor, constant: -32),
            dismissBar.rightAnchor.constraint(equalTo: l.centerXAnchor, constant: 32),
            dismissBar.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            dismissBar.bottomAnchor.constraint(equalTo: card.topAnchor, constant: 21)
        ]
        
        self.view.addSubview(dismissBar)
        NSLayoutConstraint.activate(dbCons)
        
        // Tap Gesture
        let dimTap = UITapGestureRecognizer(target: self, action: #selector(nonCardTap(_:)))
        dimTap.delegate = self
        self.view.addGestureRecognizer(dimTap)
        self.view.isUserInteractionEnabled = true
        
        // Pan Gesture
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        pan.delaysTouchesBegan = false
        pan.delaysTouchesEnded = false
        self.view.addGestureRecognizer(pan)
        
        // Table view
        tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.init(named: "element2")!
        tableView.isUserInteractionEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewCons = [
            tableView.leftAnchor.constraint(equalTo: card.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: card.rightAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: dismissBar.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: dismissBar.bottomAnchor, constant: 208)
        ]
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate(tableViewCons)
        
        // Developer label
        developerLabel = UILabel(frame: .zero)
        developerLabel.text = "© 2021 Peter Virtue, All Rights Reserved"
        developerLabel.textAlignment = .center
        developerLabel.font = UIFont.systemFont(ofSize: 12)
        developerLabel.textColor = UIColor.systemGray
        developerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let devCons = [
            developerLabel.leftAnchor.constraint(equalTo: l.leftAnchor),
            developerLabel.rightAnchor.constraint(equalTo: l.rightAnchor),
            developerLabel.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 28),
            developerLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16)
        ]
        
        self.view.addSubview(developerLabel)
        
        NSLayoutConstraint.activate(devCons)
        
    }
    
    func showCard() {
        // Layout if needed
        view.layoutIfNeeded()
        
        // Setting card view constant
        cardTopCon.constant = view.frame.height * (2 / 3)
        
        // Animation
        let showCard = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
          
        showCard.addAnimations({
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
        
        showCard.startAnimation()
        
    }
    
    @objc func nonCardTap(_ sender: UITapGestureRecognizer) {
        if !card.frame.contains(sender.location(in: self.view)) && !tableView.frame.contains(sender.location(in: self.view)) {
            goBack()
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !card.frame.contains(touch.location(in: self.view)) && !tableView.frame.contains(touch.location(in: self.view)) {
            return true
        }
        
        return false
    }
    
    @objc func viewPanned(_ sender: UIPanGestureRecognizer) {
        // User drag translation
        let loc = sender.translation(in: self.view)
        
        switch sender.state {
            case .began:
                panStart = cardTopCon.constant
            case .changed:
                if cardTopCon.constant < self.view.frame.height - self.view.safeAreaInsets.top * 2 && cardTopCon.constant > self.view.safeAreaInsets.bottom * 2 {
                    self.cardTopCon.constant = self.panStart + loc.y
                }
            case .ended:
                if cardTopCon.constant > self.view.frame.height * (4/5) {
                    goBack()
                } else {
                    showCard()
                }
            default:
                break
        }
    }
    
    func goBack() {
        self.view.layoutIfNeeded()

        cardTopCon.constant = view.frame.height
        
        // Animation
        let hideCard = UIViewPropertyAnimator(duration: 0.2, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
          
        hideCard.addAnimations {
            self.view.backgroundColor = .clear
        }

        hideCard.addCompletion({ position in
            if position == .end {
                if self.presentingViewController != nil {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        })
          
        hideCard.startAnimation()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.backgroundColor = UIColor.init(named: "element2")!
        cell.textLabel?.textColor = UIColor.init(named: "textColor")!
        cell.textLabel?.text = options[indexPath.row]
        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevron.tintColor = UIColor.systemGray3
        cell.accessoryView = chevron
        cell.imageView?.tintColor = UIColor.init(named: "pink")!
        cell.tintColor = UIColor.systemGray3
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
        // Selection color
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.init(named: "element")!
        
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
        tableView.cellForRow(at: indexPath)?.backgroundColor = UIColor.init(named: "background2")
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

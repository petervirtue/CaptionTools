//
//  previewVC.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/10/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class previewVC: UIViewController {
    
    var pv: previewView!
    var mas: NSMutableAttributedString!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        
        pv = previewView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height))
        pv.setup(mas)
        self.view = pv
        
    }
    
    // Setup
    
    func setup(_ s: NSMutableAttributedString) {
        if pv != nil {
            pv.setup(s)
        }
        
    }

}

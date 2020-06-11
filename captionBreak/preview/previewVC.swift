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
        
        pv = previewView(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: self.view.frame.height))
        pv.setup(mas)
        self.view = pv
        

        // Do any additional setup after loading the view.
    }
    
    func setup(_ s: NSMutableAttributedString) {
        print("PROBLEM HAPPENING HERE:")
        print(s)
        if pv != nil {
            pv.setup(s)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

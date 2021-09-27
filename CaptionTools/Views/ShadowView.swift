//
//  ShadowView.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/23/20.
//  Copyright © 2021 Peter Virtue. All rights reserved.
//

import UIKit

class ShadowView: UIView {

    private func setup() {

        // Create the shadow
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = CGPath(roundedRect: self.bounds, cornerWidth: 5, cornerHeight: 5, transform: nil)
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

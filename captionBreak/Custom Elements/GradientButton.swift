//
//  GradientButton.swift
//  captionBreak
//
//  Created by Peter Virtue on 6/11/20.
//  Copyright © 2020 Peter Virtue. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    
    private let grad = CAGradientLayer()
    
    func addGradient() {
        self.grad.frame = self.bounds
        self.grad.colors = [Colors.igBlue, Colors.igBlueTwo, Colors.igPurple, Colors.igPink, Colors.igPinkTwo, Colors.igRed, Colors.igOrange, Colors.igOrangeTwo, Colors.igYellow, Colors.igYellowTwo]
        self.grad.locations = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
        self.grad.startPoint = CGPoint(x: 0, y: 0)
        self.grad.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(grad, at: 0)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.grad.frame = self.bounds
    }
}

/*
gradientLayer.colors = [UIColor.black, Colors.igBlueTwo, Colors.igPurple, Colors.igPink!, Colors.igPinkTwo!, Colors.igRed!, Colors.igOrange, Colors.igOrangeTwo, Colors.igYellow!, Colors.igYellowTwo]
gradientLayer.locations = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
*/

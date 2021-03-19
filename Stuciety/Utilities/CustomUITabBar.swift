//
//  CustomUITabBar.swift
//  Stuciety
//
//  Created by bryan colin on 3/19/21.
//

import UIKit

@IBDesignable class CustomUITabBar: UITabBar {
    
    @IBInspectable var cornerRadius: CGFloat = 32.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            self.layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 2.0 {
        didSet {
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            self.layer.shadowColor = shadowColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.3 {
        didSet {
            self.layer.shadowOpacity = shadowOpacity
        }
    }
}

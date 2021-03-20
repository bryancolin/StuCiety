//
//  CustomUITabBar.swift
//  Stuciety
//
//  Created by bryan colin on 3/19/21.
//

import UIKit

@IBDesignable
class CustomUITabBar: UITabBar {
    
    @IBInspectable
    override var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
}

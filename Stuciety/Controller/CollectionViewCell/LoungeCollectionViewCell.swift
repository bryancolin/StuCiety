//
//  LoungeCollectionViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit

class LoungeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    var topic: Topic! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let topic = topic {
            featuredImageView.image = topic.featuredImage
            textLabel.text = topic.label
            view.backgroundColor = UIColor(named: K.BrandColors.lightBlue)
        }
    }
}

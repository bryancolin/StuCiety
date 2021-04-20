//
//  LoungeCollectionViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit
import RandomColorSwift

class LoungeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    var topic: Topic! {
        didSet {
            self.updateUI()
        }
    }
    
    var delegate: TableViewInsideCollectionViewDelegate?
    
    func updateUI() {
        if let topic = topic {
            featuredImageView.image = topic.featuredImage
            textLabel.text = topic.label
            view.backgroundColor = randomColor(hue: .random, luminosity: .light)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.cellTaped(topic: topic)
    }
}

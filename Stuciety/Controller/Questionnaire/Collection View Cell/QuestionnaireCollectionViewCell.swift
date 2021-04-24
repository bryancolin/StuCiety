//
//  QuestionnaireCollectionViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 4/22/21.
//

import UIKit
import RandomColorSwift

class QuestionnaireCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.lastLineFillPercent = 50
        titleLabel.linesCornerRadius = 5
    }
    
    func configure(name: String) {
        titleLabel.text = name
        view.backgroundColor = randomColor(hue: .random, luminosity: .light)
    }

}




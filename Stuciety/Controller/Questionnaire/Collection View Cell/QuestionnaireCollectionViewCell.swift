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
    @IBOutlet weak var completion: UIImageView!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.lastLineFillPercent = 50
        titleLabel.linesCornerRadius = 5
        completion.skeletonCornerRadius = Float(completion.frame.width/2)
    }
    
    func configure(name: String, complete: Bool) {
        titleLabel.text = name
        completion.isHidden = !complete
        view.backgroundColor = randomColor(hue: .random, luminosity: .light)
    }
}




//
//  LoungeCollectionViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 4/25/21.
//

import UIKit
import RandomColorSwift

class LoungeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var button: UIButton!
    
    var room: Room! {
        didSet {
            self.updateUI()
        }
    }
    
    var delegate: TableViewInsideCollectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel.lastLineFillPercent = 50
        textLabel.linesCornerRadius = 5
        
        button.skeletonCornerRadius = Float(button.frame.width/2)
    }
    
    func updateUI() {
        if let room = room {
            featuredImageView.sd_setImage(with: URL(string: room.photoURL))
            textLabel.text = room.name
            view.backgroundColor = randomColor(hue: .random, luminosity: .light)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.cellTaped(room: room)
    }
}

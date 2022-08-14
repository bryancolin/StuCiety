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
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.lastLineFillPercent = 50
            textLabel.linesCornerRadius = 5
        }
    }
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var button: UIButton! {
        didSet {
            button.skeletonCornerRadius = Float(button.frame.width/2)
        }
    }
    
    var room: Room? {
        didSet {
            self.updateUI()
        }
    }
    
    weak var delegate: CollectionViewCellTapDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI() {
        guard let room = room else { return }
        featuredImageView.sd_setImage(with: URL(string: room.photoURL))
        textLabel.text = room.name
        view.backgroundColor = randomColor(hue: .random, luminosity: .light)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.cellTaped(room: room)
    }
}

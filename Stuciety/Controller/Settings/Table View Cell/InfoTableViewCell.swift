//
//  InfoTableViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 5/1/21.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(title: String, description: String, image: UIImage) {
        titleLabel.text = title
        descriptionLabel.text = description
        img.image = image
    }
}

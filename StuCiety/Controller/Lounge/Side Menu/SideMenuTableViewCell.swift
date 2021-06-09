//
//  SideMenuTableViewCell.swift
//  StuCiety
//
//  Created by bryan colin on 6/9/21.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
    }

    func configure(name: String, photoURL: String) {
        profileName.text = name
        profileImage.sd_setImage(with: URL(string: photoURL), placeholderImage: #imageLiteral(resourceName: "stuciety_app_icon"))
    }
}

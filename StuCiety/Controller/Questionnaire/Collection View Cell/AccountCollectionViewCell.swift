//
//  AccountCollectionViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 4/22/21.
//

import UIKit
import Firebase

class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var currentUser: User? = Auth.auth().currentUser
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.linesCornerRadius = 5
        statusLabel.linesCornerRadius = 5
        
        profilePicture.layer.cornerRadius = 5
        profilePicture.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    func configure() {
        if let user = currentUser {
            nameLabel.text = user.displayName
            guard let imageURL = user.photoURL?.absoluteString else { return }
            profilePicture.sd_setImage(with: URL(string: imageURL), placeholderImage: #imageLiteral(resourceName: "stuciety_app_icon"))
            
//            let imageColor = profilePicture.image?.averageColor ?? .clear
//            sideView.backgroundColor = imageColor
//            nameLabel.textColor = imageColor
//            statusLabel.textColor = imageColor
        }
    }
}

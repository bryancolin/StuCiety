//
//  CounselorTableViewCell.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import UIKit

class CounselorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var counselorArea: UILabel!
    @IBOutlet weak var counselorPhoto: UIImageView!
    
    var counselor: Counselor! {
        didSet {
            self.updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        counselorPhoto.layer.masksToBounds = false
        counselorPhoto.layer.borderColor = UIColor.black.cgColor
        counselorPhoto.layer.cornerRadius = counselorPhoto.frame.height/2
        counselorPhoto.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI() {
        if let counselor = counselor {
            counselorName.text = counselor.displayName
            counselorArea.text = "Area: \(counselor.area[0])"
            counselorPhoto.image = counselor.photo
        }
    }
}

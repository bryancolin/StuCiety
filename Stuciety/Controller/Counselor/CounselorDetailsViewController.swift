//
//  CounselorDetailsViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import UIKit

class CounselorDetailsViewController: UIViewController {
    
    @IBOutlet weak var counselorPhoto: UIImageView!
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var counselorBio: UILabel!
    @IBOutlet weak var counselorLicense: UILabel!
    @IBOutlet weak var counselorArea: UILabel!
    
    var counselorDetails: Counselor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.purple)
        
        if let counselor = counselorDetails {
            counselorPhoto.image = counselor.photo
            counselorName.text = counselor.displayName
            counselorBio.text = counselor.biography
            counselorLicense.text = counselor.license[0] + "\n" + counselor.license[1]
            for (index, area) in counselor.area.enumerated() {
                counselorArea.text! += area
                if index < counselor.area.count-1 {
                    counselorArea.text! += ", "
                }
            }
        }
    }
}

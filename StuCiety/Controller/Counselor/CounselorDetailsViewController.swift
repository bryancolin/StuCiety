//
//  CounselorDetailsViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import UIKit
import SDWebImage

class CounselorDetailsViewController: UIViewController {
    
    @IBOutlet weak var counselorPhoto: UIImageView!
    @IBOutlet weak var counselorName: UILabel!
    @IBOutlet weak var counselorBio: UILabel!
    @IBOutlet weak var counselorLicense: UILabel!
    @IBOutlet weak var counselorArea: UILabel!
    
    var counselorDetails: Counselor? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Counselor.Segue.chat {
            if let destinationVC = segue.destination as? CounselorChatViewController {
                destinationVC.counselor = counselorDetails
            }
        }
    }
    
    private func updateUI() {
        guard let counselor = counselorDetails else { return }
        counselorName.text = counselor.displayName
        counselorBio.text = counselor.biography
        counselorLicense.text = counselor.license[0] + "\n" + counselor.license[1]
        for (index, area) in counselor.area.enumerated() {
            counselorArea.text! += area
            if index < counselor.area.count-1 {
                counselorArea.text! += ", "
            }
        }
        counselorPhoto.sd_setImage(with: URL(string: counselor.photo))
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.Counselor.Segue.chat, sender: self)
    }
}

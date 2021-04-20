//
//  AccountViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/8/21.
//

import UIKit
import Firebase
import ProgressHUD

class AccountViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var currentUser: User? = Auth.auth().currentUser
    
    override func viewWillAppear(_ animated: Bool) {
        setupImageView()
        
        if let image = currentUser?.photoURL {
            let imageURL = image.absoluteString
            getProfile(with: imageURL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.purple)
    }
    
    func setupImageView() {
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
    }
    
    //Call this function in VC where your `ImageView` is
    func getProfile(with Url: String){
        DispatchQueue.global().async {
            let url = URL(string: Url)
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    self.profilePicture.image = UIImage(data: data)
                    self.nameLabel.text = self.currentUser?.displayName
                }
            }
        }
    }
}



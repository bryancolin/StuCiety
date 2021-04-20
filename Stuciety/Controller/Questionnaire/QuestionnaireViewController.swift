//
//  QuestionnaireViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/20/21.
//

import UIKit
import Firebase
import SkeletonView

class QuestionnaireViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    var currentUser: User? = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        // Do any additional setup after loading the view.
        if let user = currentUser {
            nameLabel.text = user.displayName
            
            guard let imageURL = user.photoURL?.absoluteString else { return }
            let url = URL(string: imageURL)
            guard let data = try? Data(contentsOf: url!) else { return }
            profilePicture.image = UIImage(data: data)
            
        }
        
        showAnimatedGradient()
    }
    
    func showAnimatedGradient() {
        nameLabel.showAnimatedGradientSkeleton(usingGradient: K.gradient)
        statusLabel.showAnimatedGradientSkeleton(usingGradient: K.gradient)
        profilePicture.showAnimatedGradientSkeleton(usingGradient: K.gradient)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
            nameLabel.hideSkeleton(transition: .crossDissolve(0.25))
            statusLabel.hideSkeleton(transition: .crossDissolve(0.25))
            profilePicture.hideSkeleton(transition: .crossDissolve(0.25))
        }
    }
}

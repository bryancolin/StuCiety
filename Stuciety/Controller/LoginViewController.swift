//
//  LoginViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/16/21.
//

import UIKit
import Firebase
import ProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: CustomUITextField!
    @IBOutlet weak var passwordTextField: CustomUITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: CustomUIButton) {
        ProgressHUD.showProgress(0.42)
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    ProgressHUD.showFailed("Invalid email or password")
                } else {
                    self.performSegue(withIdentifier: K.Segue.login, sender: self)
                    print("Successfully login")
                }
            }
        }
    }
}

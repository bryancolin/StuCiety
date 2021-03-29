//
//  RegisterViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/17/21.
//

import UIKit
import ProgressHUD
import Validator

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomUITextField!
    @IBOutlet weak var emailTextField: CustomUITextField!
    @IBOutlet weak var passwordTextField: CustomUITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        guard nameTextField.text != "" else {
            return ProgressHUD.showError("Name field is empty")
        }
        
        guard emailTextField.text != "" else {
            return ProgressHUD.showError("Email field is empty")
        }
        
        guard passwordTextField.text != "" else {
            return ProgressHUD.showError("Password field is empty")
        }
    }
}

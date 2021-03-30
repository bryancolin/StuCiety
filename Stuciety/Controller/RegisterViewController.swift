//
//  RegisterViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/17/21.
//

import UIKit
import Firebase
import ProgressHUD

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: CustomUITextField!
    @IBOutlet weak var emailTextField: CustomUITextField!
    @IBOutlet weak var passwordTextField: CustomUITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameTextField.tag = 0
        self.emailTextField.tag = 1
        self.passwordTextField.tag = 2
        
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        ProgressHUD.show()
        
        guard nameTextField.text != "" else {
            return ProgressHUD.showError("Name field is empty")
        }
        
        guard emailTextField.text != "" else {
            return ProgressHUD.showError("Email field is empty")
        }
        
        guard isValidEmail(emailTextField.text!) else {
            return ProgressHUD.showError("Email is not valid")
        }
        
        guard passwordTextField.text != "" else {
            return ProgressHUD.showError("Password field is empty")
        }
        
        guard isValidPassword(passwordTextField.text!) else {
            return ProgressHUD.showError("Password is not strong enough")
        }
        
        if let name = nameTextField.text ,let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    ProgressHUD.showFailed("Email have been registered. Please try again with another email")
                } else {
                    self.db.collection("students").addDocument(data: ["name": name, "email": email, "result": "", "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            ProgressHUD.showFailed("Error saving user data")
                        }
                    }
                    
                    self.performSegue(withIdentifier: K.Segue.register, sender: self)
                }
            }
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

//MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1
        
        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
}

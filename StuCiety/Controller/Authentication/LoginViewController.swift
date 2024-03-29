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
    
    typealias Result = Bool
    typealias Error = String
    
    @IBOutlet weak var emailTextField: CustomUITextField! {
        didSet {
            emailTextField.tag = 0
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: CustomUITextField! {
        didSet {
            passwordTextField.tag = 1
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed(_ sender: CustomUIButton) {
        
        ProgressHUD.show()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return ProgressHUD.showError("Something went wrong. Please try again")
        }
        
        Task { [weak self] in
            let args = await self?.handleLogin(with: email, password: password)
            
            if args?.0 ?? false {
                self?.performSegue(withIdentifier: K.Segue.login, sender: self)
                ProgressHUD.dismiss()
            } else {
                ProgressHUD.showFailed(args?.1)
            }
        }
    }
    
    @MainActor
    private func handleLogin(with email: String, password: String) async -> (Result, Error) {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            return (true, "")
        } catch {
            let errorMessage: String
            switch AuthErrorCode(rawValue: error._code)  {
            case .invalidEmail:
                errorMessage = "Invalid email. Please try again."
            case .wrongPassword:
                errorMessage = "Wrong Password. Please try again."
            case .networkError:
                errorMessage = "Network error. Please try again."
            default:
                errorMessage = "Unknown error occurred"
            }
            return (false, errorMessage)
        }
    }
}

//MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
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

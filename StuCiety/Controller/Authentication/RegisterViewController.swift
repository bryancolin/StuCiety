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
        
        nameTextField.tag = 0
        emailTextField.tag = 1
        passwordTextField.tag = 2
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        ProgressHUD.show()
        
        guard nameTextField.text != "" else { return ProgressHUD.showError("Name field is empty") }
        
        guard emailTextField.text != "" else { return ProgressHUD.showError("Email field is empty") }
        guard isValidEmail(emailTextField.text!) else { return ProgressHUD.showError("Email is not valid") }
        
        guard passwordTextField.text != "" else { return ProgressHUD.showError("Password field is empty") }
        guard isValidPassword(passwordTextField.text!) else { return ProgressHUD.showError("Password is not strong enough") }
        
        guard let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {
            return ProgressHUD.showError("Something went wrong. Please try again")
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {[self] (result, error) in
            if let e = error {
                if let errorCode = AuthErrorCode(rawValue: e._code) {
                    switch errorCode {
                    case .emailAlreadyInUse:
                        ProgressHUD.showFailed("Email is already registered. Please try again with another email.")
                    case .networkError:
                        ProgressHUD.showFailed("Network error. Please try again.")
                    default:
                        ProgressHUD.showFailed("Unknown error occurred")
                    }
                }
            } else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                
                changeRequest?.commitChanges(completion: { error in
                    guard error == nil else { return ProgressHUD.showFailed("Something went wrong. Please try again.") }
                    
                    let newStudent = Student(email: email, name: name, photoURL: "", result: "", questionnaires: [:])
                    
                    do {
                        let _ = try db.collection(K.FStore.Student.collectionName).document(result!.user.uid).setData(from: newStudent)
                        ProgressHUD.dismiss()
                        performSegue(withIdentifier: K.Segue.register, sender: self)
                    }
                    catch {
                        print(error)
                    }
                })
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

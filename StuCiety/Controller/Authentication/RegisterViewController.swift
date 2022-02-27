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
    
    @IBOutlet weak var nameTextField: CustomUITextField! {
        didSet {
            nameTextField.tag = 0
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: CustomUITextField! {
        didSet {
            emailTextField.tag = 1
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: CustomUITextField! {
        didSet {
            passwordTextField.tag = 2
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        ProgressHUD.show()
        
        guard let name = nameTextField.text else { return ProgressHUD.showError("Name field is empty") }
        
        guard let email = emailTextField.text else { return ProgressHUD.showError("Email field is empty") }
        guard email.isValidEmail() else { return ProgressHUD.showError("Email is not valid") }
        
        guard let password = passwordTextField.text else { return ProgressHUD.showError("Password field is empty") }
        guard password.isValidPassword() else { return ProgressHUD.showError("Password is not strong enough") }
        
        Auth.auth().createUser(withEmail: email, password: password) {[self] (result, error) in
            if let e = error, let errorCode = AuthErrorCode(rawValue: e._code) {
                switch errorCode {
                case .emailAlreadyInUse:
                    ProgressHUD.showFailed("Email is already registered. Please try again with another email.")
                case .networkError:
                    ProgressHUD.showFailed("Network error. Please try again.")
                default:
                    ProgressHUD.showFailed("Unknown error occurred")
                }
            } else {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                
                changeRequest?.commitChanges(completion: { error in
                    guard error == nil else { return ProgressHUD.showFailed("Something went wrong. Please try again.") }
                    
                    let newStudent = Student(email: email, name: name, photoURL: "", result: "", questionnaires: [:])
                    
                    do {
                        let _ = try db.collection(K.FStore.Student.collectionName).document(result!.user.uid)
                            .setData(from: newStudent)
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

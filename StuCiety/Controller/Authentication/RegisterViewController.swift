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
    
    typealias Result = Bool
    typealias Error = String
    
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
        
        guard nameTextField.text != "", let name = nameTextField.text else { return ProgressHUD.showError("Name field is empty") }
        
        guard emailTextField.text != "" else { return ProgressHUD.showError("Email field is empty") }
        guard let email = emailTextField.text, email.isValidEmail() else { return ProgressHUD.showError("Email is not valid") }
        
        guard passwordTextField.text != "" else { return ProgressHUD.showError("Password field is empty") }
        guard let password = passwordTextField.text, password.isValidPassword() else { return ProgressHUD.showError("Password is not strong enough") }
        
        Task { [weak self] in
            let args = await self?.handleRegister(name: name, email: email, password: password)
            
            if args?.0 ?? false {
                self?.performSegue(withIdentifier: K.Segue.register, sender: self)
                ProgressHUD.dismiss()
            } else {
                ProgressHUD.showFailed(args?.1)
            }
        }
    }
    
    @MainActor
    private func handleRegister(name: String, email: String, password: String) async -> (Result, Error) {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else { return (false, "") }
            changeRequest.displayName = name
            let _ = try await changeRequest.commitChanges()
            
            // Create new student
            let newStudent = Student(email: email, name: name, photoURL: "", result: "", questionnaires: [:])
            let _ = try db.collection(K.FStore.Student.collectionName).document(result.user.uid).setData(from: newStudent)
            
            return (true, "")
        } catch {
            let errorMessage: String
            switch AuthErrorCode(rawValue: error._code) {
            case .emailAlreadyInUse:
                errorMessage = "Email is already registered. Please try again with another email."
            case .networkError:
                errorMessage = "Network error. Please try again."
            default:
                errorMessage = "Unkown error occured"
            }
            
            return (false, errorMessage)
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

//
//  AddImagesViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/7/21.
//

import UIKit
import Firebase
import ProgressHUD

class AddPhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    private var currentUser: User? = Auth.auth().currentUser
    private var imageData: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        label.text = "Welcome, \(currentUser?.displayName ?? "No-User")"
        nextButton.isHidden = true
        setupImageView()
    }
    
    func setupImageView() {
        imageView.image = #imageLiteral(resourceName: "DefaultProfileImage").withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    @IBAction func chooseImage(_ sender: UIButton) {
        showChooseSourceTypeAlertController()
    }
    
    @IBAction func complete(_ sender: Any) {
        
        ProgressHUD.show()
        
        guard imageData != nil else {
            return ProgressHUD.showFailed("Please select image")
        }
        
        guard let image = imageData?.pngData() else {
            return ProgressHUD.showFailed("Failed to compress")
        }
        
        let thisUserPhotoStorageRef = storage.child("users/\(currentUser?.uid ?? "-1")").child("photo.png")
        
        thisUserPhotoStorageRef.putData(image, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                return ProgressHUD.showFailed("Error while uploading")
            }
            
            thisUserPhotoStorageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    return ProgressHUD.showFailed("An error occured after uploading and then getting the URL")
                }
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = downloadURL
                
                changeRequest?.commitChanges(completion: { (error) in
                    if error != nil {
                        ProgressHUD.showFailed("Something went wrong. Please try again.")
                    } else {
                        self.db.collection("students").document(self.currentUser?.uid ?? "0").updateData([
                            "photoURL": downloadURL.absoluteString
                        ]) { error in
                            if error != nil {
                                ProgressHUD.showFailed("Error saving user photo")
                            } else {
                                ProgressHUD.dismiss()
                                self.performSegue(withIdentifier: K.Segue.profile, sender: self)
                            }
                        }
                    }
                })
            }
            
        }
    }
}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func showChooseSourceTypeAlertController() {
        // create the alert
        let alert = UIAlertController(title: "Profile Picture", message: "Choose actions", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Choose a Photo", style: .default) { (action) in self.showImagePickerController(sourceType: .photoLibrary)
        })
        alert.addAction(UIAlertAction(title: "Take a New Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = editedImage.withRenderingMode(.alwaysOriginal)
            imageData = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = originalImage.withRenderingMode(.alwaysOriginal)
            imageData = originalImage
        }
        
        nextButton.isHidden = false
        
        dismiss(animated: true, completion: nil)
    }
}

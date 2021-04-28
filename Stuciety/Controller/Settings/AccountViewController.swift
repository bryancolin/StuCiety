//
//  AccountViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/8/21.
//

import UIKit
import Firebase
import FirebaseStorage
import ProgressHUD

class AccountViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let storage = Storage.storage().reference()
    private let db = Firestore.firestore()
    private var currentUser: User? = Auth.auth().currentUser
    private var imageData: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        if let imageURL = currentUser?.photoURL?.absoluteString {
            getProfile(with: imageURL)
        }
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
    
    func saveImage() {
        ProgressHUD.show()
        
        guard imageData != nil else { return ProgressHUD.showFailed("Please select an image") }
        guard let image = imageData?.jpegData(compressionQuality: 0.5) else { return ProgressHUD.showFailed("Failed to compress") }
        
        let thisUserPhotoStorageRef = storage.child("users/\(currentUser?.uid ?? "-1")").child("photo.jpeg")
        
        thisUserPhotoStorageRef.putData(image, metadata: nil) { (metadata, error) in
            guard metadata != nil else { return ProgressHUD.showFailed("Error while uploading") }
            
            thisUserPhotoStorageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return ProgressHUD.showFailed("An error occured after uploading and then getting the URL") }
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = downloadURL
                
                changeRequest?.commitChanges(completion: { [self] (error) in
                    guard error == nil else { return ProgressHUD.showFailed("Something went wrong. Please try again.") }
                    
                    db.collection(K.FStore.Student.collectionName).document(currentUser?.uid ?? "0").updateData([
                        K.FStore.Student.photoURL: downloadURL.absoluteString
                    ]) { error in
                        guard error == nil else { return ProgressHUD.showFailed("Error saving user photo") }
                        
                        ProgressHUD.showSucceed()
                    }
                })
            }
        }
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        showChooseSourceTypeAlertController()
    }
}

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        alert.addAction(UIAlertAction(title: "Choose a Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
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
            self.profilePicture.image = editedImage.withRenderingMode(.alwaysOriginal)
            imageData = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profilePicture.image = originalImage.withRenderingMode(.alwaysOriginal)
            imageData = originalImage
        }
        
        dismiss(animated: true, completion: nil)
        
        saveImage()
    }
}



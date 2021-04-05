//
//  ChatViewController.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import UIKit
import Firebase

class ChatsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var roomTitle: String?
    
    var messages = ["Hello", "test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.purple)
        self.title = roomTitle
        
        messageTextField.delegate = self
        tableView.dataSource = self
        
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName).document(roomTitle!.lowercased()).collection(K.FStore.childCollectionName).addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        print(data[K.FStore.senderField], data[K.FStore.bodyField])
//                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
//
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
//                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
//                            }
//                        }
                    }
                    
                    
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        performAction()
    }
    
    func performAction() {
        if messageTextField.text != "" {
            if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.uid {
                db.collection(K.FStore.collectionName).document(roomTitle!.lowercased()).collection(K.FStore.childCollectionName).addDocument(data: [
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                    if let e = error {
                        print("There was an issue retrieving data from Firestore. \(e)")
                    } else {
                        self.messageTextField.text = ""
                        print("Successfully saved data.")
                    }
                }
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension ChatsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
}

//MARK: - UITableViewDataSource

extension ChatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Room.cellIdentifier, for: indexPath) as UITableViewCell
        //        cell.textLabel?.text = messages[indexPath.row]
        
        return cell
    }
}

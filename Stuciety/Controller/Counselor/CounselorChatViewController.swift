//
//  CounselorChatViewController.swift
//  Stuciety
//
//  Created by bryan colin on 5/2/21.
//

import UIKit
import SDWebImage
import Firebase
import MessageKit
import InputBarAccessoryView
import IQKeyboardManagerSwift

class CounselorChatViewController: MessagesViewController {
    
    var messages: [Message] = []
    var counselor: Counselor?
    
    let db = Firestore.firestore()
    var currentUser: User = Auth.auth().currentUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = counselor?.displayName
        
        configureMessageCollectionView()
        messagesCollectionView.messagesDataSource = self
        
        messageInputBar = CustomUIInputBar()
        messageInputBar.delegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].senderId == messages[indexPath.section - 1].senderId
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].senderId  == messages[indexPath.section + 1].senderId
    }
    
    private func checkEmptyMessage() {
        if messages.isEmpty == true {
            if let counselor = counselor {
                let newMessage = Message(id: UUID().uuidString, body: "Hi, how can i help you with?", createdAt: Date().timeIntervalSince1970, senderId: counselor.id!, senderName: counselor.displayName)
                save(newMessage)
            }
        }
    }
    
    private func loadMessages() {
        
        db.collection(K.FStore.Counselor.collectionName).document(counselor?.id ?? "")
            .collection(K.FStore.Counselor.firstChildCollectionName).document(currentUser.uid)
            .collection(K.FStore.Counselor.secondChildCollectionName)
            .order(by: K.FStore.Message.dateField, descending: false)
            .addSnapshotListener { [self] (querySnapshot, error) in
                messages = []
                
                guard error == nil else { return print("There was an issue retrieving data from Firestore.") }
                guard let snapshotDocuments = querySnapshot?.documents else { return print("No documents") }
                
                messages = snapshotDocuments.compactMap { (QueryDocumentSnapshot) -> Message? in
                    return try? QueryDocumentSnapshot.data(as: Message.self)
                }
                
               checkEmptyMessage()
                
                DispatchQueue.main.async {
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem()
                }
            }
    }
    
    private func save(_ message: Message) {
        
        do {
            let _ = try db.collection(K.FStore.Counselor.collectionName).document(counselor?.id ?? "")
                .collection(K.FStore.Counselor.firstChildCollectionName).document(currentUser.uid)
                .collection(K.FStore.Counselor.secondChildCollectionName).addDocument(from: message)
            print("Document successfully written!")
        } catch {
            print(error)
        }
    }
}

//MARK: - MessagesDataSource

extension CounselorChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(senderId: currentUser.uid, displayName: currentUser.displayName ?? "Unknown")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            return NSAttributedString(string: message.sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 11)])
        }
        return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message) {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            return NSAttributedString(string: formatter.string(from: message.sentDate), attributes: [.font: UIFont.systemFont(ofSize: 10)])
        }
        return nil
    }
}

//MARK: - MessagesLayoutDelegate

extension CounselorChatViewController: MessagesLayoutDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let photoURL = message.sender.senderId == counselor?.id ? URL(string: counselor?.photo ?? "") : URL(string: currentUser.photoURL?.absoluteString ?? "")
        avatarView.sd_setImage(with: photoURL)
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isTimeLabelVisible(at: indexPath) ? 18 : 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 2
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
}

//MARK: - MessagesDisplayDelegate

extension CounselorChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .clear : UIColor(named: K.BrandColors.purple)! as UIColor
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.black : UIColor.white
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in  messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .custom { [self] view in
            view.borderWidth = 1
            view.borderColor = isFromCurrentSender(message: message) ? UIColor(named: K.BrandColors.purple)! as UIColor : .clear
            view.layer.cornerRadius = 16
            view.layer.masksToBounds = false
        }
    }
}

//MARK: - InputBarAccessoryViewDelegate

extension CounselorChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = Message(id: UUID().uuidString, body: text, createdAt: Date().timeIntervalSince1970, senderId: currentUser.uid, senderName: currentUser.displayName ?? "Unkown")
        
        // Empty TextField
        inputBar.inputTextView.text = String()
        
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async {
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Enter a message"
                
                // Save Messages
                self.save(newMessage)
            }
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didSwipeTextViewWith gesture: UISwipeGestureRecognizer) {
        inputBar.inputTextView.resignFirstResponder()
    }
}

//
//  ChatViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/5/21.
//

import UIKit
import Firebase
import InputBarAccessoryView
import IQKeyboardManagerSwift
import MessageKit



class ChatViewController: MessagesViewController {
    
    var roomTitle: String?
    
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    var currentUser: User = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = roomTitle
        
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
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
        
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        
        layout?.setMessageIncomingAvatarSize(.zero)
        layout?.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)))
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)))
        
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
    
    private func loadMessages() {
        
        db.collection(K.FStore.Message.collectionName).document(roomTitle!.lowercased()).collection(K.FStore.Message.childCollectionName)
            .order(by: K.FStore.Message.dateField, descending: false)
            .addSnapshotListener { [self] (querySnapshot, error) in
                messages = []
                
                if let e = error {
                    print("There was an issue retrieving data from Firestore. \(e)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            if let message = Message(dictionary: doc.data()) {
                                messages.append(message)
                                
                                DispatchQueue.main.async {
                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToLastItem()
                                }
                            }
                        }
                    }
                }
            }
    }
    
    private func save(_ message: Message) {
        
        let data: [String: Any] = [
            K.FStore.Message.idField: message.id,
            K.FStore.Message.bodyField: message.body,
            K.FStore.Message.dateField: message.createdAt,
            K.FStore.Message.senderIdField: message.senderId,
            K.FStore.Message.senderNameField: message.senderName
        ]
        
        db.collection(K.FStore.Message.collectionName).document(roomTitle!.lowercased()).collection(K.FStore.Message.childCollectionName).addDocument(data: data) { (error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                print("Successfully saved data.")
            }
        }
    }
}

//MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
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

extension ChatViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isTimeLabelVisible(at: indexPath) ? 18 : 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 5
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
}

//MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    
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

extension ChatViewController: InputBarAccessoryViewDelegate {
    
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

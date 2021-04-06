//
//  ChatViewController.swift
//  Stuciety
//
//  Created by bryan colin on 4/5/21.
//

import UIKit
import Firebase
import InputBarAccessoryView
import MessageKit

struct Message {
    let senderId: String
    let senderName: String
    let created: Double
    let text: String
    let messageId: String
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: senderName)
    }
    
    var sentDate: Date {
        return NSDate(timeIntervalSince1970: created) as Date
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}

class ChatViewController: MessagesViewController {
    
    var roomTitle: String?
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    var currentUser: User = Auth.auth().currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = roomTitle
        self.navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColors.purple)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar = CustomUIInputBar()
        messageInputBar.delegate = self
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
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: message.sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 11)])
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return NSAttributedString(string: formatter.string(from: message.sentDate), attributes: [.font: UIFont.systemFont(ofSize: 10)])
    }
}

//MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 1
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
}

//MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(named: K.BrandColors.purple)! as UIColor : .clear
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.white : UIColor.black
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //        let message = messages[indexPath.section]
        //        let color = message.member.color
        //        avatarView.backgroundColor = color
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in  messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let borderColor: UIColor = isFromCurrentSender(message: message) ? .clear: UIColor(named: K.BrandColors.purple)! as UIColor
        return .bubbleOutline(borderColor)
    }
}

//MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let newMessage = Message(senderId: currentUser.uid, senderName: currentUser.displayName ?? "Unkown", created: Date().timeIntervalSince1970, text: text, messageId: UUID().uuidString)
        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Enter a message"
                
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem()
            }
        }
    }
}

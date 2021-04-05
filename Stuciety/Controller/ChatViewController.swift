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
        
        messageInputBar.delegate = self
        messageInputBar = iMessageInputBar()
        messageInputBar.inputTextView.placeholder = "Enter a message"
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
                inputBar.inputTextView.placeholder = "Aa"
                
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem()
            }
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        inputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        if #available(iOS 13, *) {
            inputBar.inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
        } else {
            inputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        }
        inputBar.inputTextView.layer.borderWidth = 1.0
        inputBar.inputTextView.layer.cornerRadius = 16.0
        inputBar.inputTextView.layer.masksToBounds = true
        inputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputBar.setRightStackViewWidthConstant(to: 38, animated: false)
//        inputBar.setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
//        inputBar.sendButton.imageView?.backgroundColor = tintColor
        inputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        inputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        inputBar.sendButton.image = #imageLiteral(resourceName: "ic_up")
        inputBar.sendButton.title = nil
        inputBar.sendButton.imageView?.layer.cornerRadius = 16
        inputBar.sendButton.backgroundColor = .clear
        inputBar.middleContentViewPadding.right = -38
        inputBar.separatorLine.isHidden = true
        inputBar.isTranslucent = true
    }
}

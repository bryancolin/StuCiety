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
import SideMenu

class ChatViewController: MessagesViewController {
    
    var roomTitle: String = "Room" {
        didSet {
            self.title = roomTitle
        }
    }
    
    typealias tuple = (displayName: String, photoURL: String, exists: Bool)
    private var users = [String: tuple]()
    private var messages: [Message] = []
    
    private let db = Firestore.firestore()
    private let currentUser: User = Auth.auth().currentUser!
    private var listener: ListenerRegistration? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMessageCollectionView()
        configureMessageInputBar()
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        loadMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Lounge.Segue.sideMenu {
            if let navViewController = segue.destination as? SideMenuNavigationController {
                guard let sideMenu = navViewController.viewControllers.first as? SideMenuTableViewController else { return }
                
                navViewController.presentationStyle = .menuSlideIn
                navViewController.blurEffectStyle = .light

                SideMenuManager.default.rightMenuNavigationController = navViewController
                SideMenuManager.default.addPanGestureToPresent(toView: self.view)

                sideMenu.users = users
            }
        }
    }
    
    @IBAction func userButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.Lounge.Segue.sideMenu, sender: self)
    }
    
    private func configureMessageCollectionView() {
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesDataSource = self
    }
    
    private func configureMessageInputBar() {
        messageInputBar = CustomUIInputBar()
        messageInputBar.delegate = self
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [self] in
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToLastItem()
        }
    }
    
    private func loadUsers() {
        let filteredUsers = users.filter { ($0.value.photoURL == "" && $0.value.exists )}
        
        if !filteredUsers.isEmpty {
            for (id, _) in filteredUsers {
                db.collection(K.FStore.Student.collectionName).document(id).getDocument { [self] (document, error) in
                    guard let document = document, document.exists else {
                        users[id]?.exists = false
                        reloadTable()
                        print("Document does not exist")
                        return
                    }
                    
                    guard let displayName = document.get(K.FStore.Student.name) as? String,
                          let photoURL = document.get(K.FStore.Student.photoURL) as? String else { return }
                    
                    users[id] = tuple(displayName: displayName, photoURL: photoURL, exists: true)
                    
                    reloadTable()
                }
            }
        } else {
            reloadTable()
        }
    }
    
    private func loadMessages() {
        listener = db.collection(K.FStore.Message.collectionName).document(roomTitle.lowercased())
            .collection(K.FStore.Message.childCollectionName).order(by: K.FStore.Message.dateField, descending: false)
            .addSnapshotListener { [self] (querySnapshot, error) in
                
                guard error == nil else { return print("There was an issue retrieving data from Firestore.") }
                guard let snapshotDocuments = querySnapshot?.documents else { return print("No documents") }
                
                messages = snapshotDocuments.compactMap { (queryDocumentSnapshot) -> Message? in
                    guard let message = try? queryDocumentSnapshot.data(as: Message.self) else { fatalError() }
                    if users[message.senderId] == nil {
                        users[message.senderId] = tuple(displayName: message.senderName, photoURL: "", exists: true)
                    }
                    return message
                }
                
                DispatchQueue.main.async {
                    self.loadUsers()
                }
            }
    }
    
    private func save(_ message: Message) {
        do {
            let _ = try db.collection(K.FStore.Message.collectionName).document(roomTitle.lowercased())
                .collection(K.FStore.Message.childCollectionName).addDocument(from: message)
            print("Document successfully written!")
        } catch {
            print(error)
        }
    }
}

//MARK: - Helpers

extension ChatViewController {
    
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
        let sender = message.sender
        if !isPreviousMessageSameSender(at: indexPath) {
            return NSAttributedString(string: users[sender.senderId]?.displayName ?? sender.displayName, attributes: [.font: UIFont.systemFont(ofSize: 11)])
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
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.sd_setImage(with: URL(string: users[message.sender.senderId]?.photoURL ?? ""), placeholderImage: #imageLiteral(resourceName: "stuciety_app_icon"))
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
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

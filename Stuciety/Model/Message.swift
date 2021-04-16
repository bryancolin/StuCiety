//
//  Message.swift
//  Stuciety
//
//  Created by bryan colin on 3/29/21.
//

import Foundation
import MessageKit

struct Message {
    let id: String
    let body: String
    let createdAt: Double
    let senderId: String
    let senderName: String
}

extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary[K.FStore.Message.idField] as? String,
              let messageBody = dictionary[K.FStore.Message.bodyField] as? String,
              let createdAt = dictionary[K.FStore.Message.dateField] as? Double,
              let senderId = dictionary[K.FStore.Message.senderIdField] as? String,
              let senderName = dictionary[K.FStore.Message.senderNameField] as? String else { return nil }
        
        self.init(id: id, body: messageBody, createdAt: createdAt, senderId: senderId, senderName: senderName)
    }
}

extension Message: MessageType {
    var messageId: String {
        return id
    }
    
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: senderName)
    }
    
    var sentDate: Date {
        return NSDate(timeIntervalSince1970: createdAt) as Date
    }
    
    var kind: MessageKind {
        return .text(body)
    }
}

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

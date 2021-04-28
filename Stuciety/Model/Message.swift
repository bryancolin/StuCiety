//
//  Message.swift
//  Stuciety
//
//  Created by bryan colin on 3/29/21.
//

import Foundation
import FirebaseFirestoreSwift
import MessageKit

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    let body: String
    let createdAt: Double
    let senderId: String
    let senderName: String
    
    enum CodingKeys: String, CodingKey {
        case body
        case createdAt
        case senderId
        case senderName
    }
}

extension Message: MessageType {
    var sender: SenderType {
        return Sender(senderId: senderId, displayName: senderName)
    }
    
    var messageId: String {
        return id ?? "0"
    }
    
    var sentDate: Date {
        return NSDate(timeIntervalSince1970: createdAt) as Date
    }
    
    var kind: MessageKind {
        return .text(body)
    }
}



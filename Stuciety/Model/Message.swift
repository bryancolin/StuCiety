//
//  Message.swift
//  Stuciety
//
//  Created by bryan colin on 3/29/21.
//

import Foundation
import MessageKit

//
//struct Message {
//    let sender: String
//    let body: String
//    let date: Date
//}

//struct Message {
//    var id: String
//    var content: String
//    var created: Date
//    var senderID: String
//    var senderName: String
//    var dictionary: [String: Any] {
//        return [
//            "id": id,
//            "content": content,
//            "created": created,
//            "senderID": senderID,
//            "senderName":senderName]
//    }
//}
//
//extension Message {
//    init?(dictionary: [String: Any]) {
//        guard let id = dictionary["id"] as? String,
//              let content = dictionary["content"] as? String,
//              let created = dictionary["created"] as? Date,
//              let senderID = dictionary["senderID"] as? String,
//              let senderName = dictionary["senderName"] as? String
//        else {return nil}
//        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName)
//    }
//}
//
//extension Message: MessageType {
//
//    var sender: SenderType {
//        return Sender(id: senderID, displayName: senderName)
//    }
//
//    var messageId: String {
//        return id
//    }
//
//    var sentDate: Date {
//        return created
//    }
//
//    var kind: MessageKind {
//        return .text(content)
//    }
//}

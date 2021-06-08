//
//  Room.swift
//  StuCiety
//
//  Created by bryan colin on 6/8/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Room: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var category: String
    var photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case photoURL
    }
}

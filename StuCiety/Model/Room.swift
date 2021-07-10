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
    var category: Category
    var photoURL: String
    
    enum Category: String, Codable {
        case general
        case subjects
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case category
        case photoURL
    }
}

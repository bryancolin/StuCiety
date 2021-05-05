//
//  Counselor.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Counselor: Identifiable, Codable {
    @DocumentID var id: String?
    var displayName: String
    var email: String
    var biography: String
    var area: [String]
    var license: [String]
    var photo: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
        case email
        case biography
        case area
        case license
        case photo = "photoURL"
    }
}

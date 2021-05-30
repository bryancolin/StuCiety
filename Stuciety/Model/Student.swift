//
//  Student.swift
//  Stuciety
//
//  Created by bryan colin on 4/30/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Student: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var name: String
    var photoURL: String
    var result: String
    var questionnaires: [String: Bool]
    
    enum CodingKeys: String, CodingKey {
        case email
        case name = "displayName"
        case photoURL
        case result
        case questionnaires
    }
}

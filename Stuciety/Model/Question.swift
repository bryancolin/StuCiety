//
//  Question.swift
//  Stuciety
//
//  Created by bryan colin on 4/24/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Question: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var answer: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case answer
    }
}

extension Question {
    init?(no: String, dictionary: [String: Any]) {
        guard let text = dictionary[K.FStore.Questionnaire.Child.text] as? String else { return nil }
        self.init(id: no, text: text, answer: "")
    }
}

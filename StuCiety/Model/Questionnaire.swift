//
//  Questionnaire.swift
//  Stuciety
//
//  Created by bryan colin on 4/23/21.
//

import Foundation
import Firebase

struct Questionnaire {
    var id: String
    var title: String
    var description: String
    var createdBy: String
    var questions: [Question]
}

extension Questionnaire {
    init?(uid: String, dictionaryField: [String: Any], questions: [Question]) {
        
        guard let title = dictionaryField[K.FStore.Questionnaire.title] as? String,
              let description = dictionaryField[K.FStore.Questionnaire.description] as? String,
              let createdBy = dictionaryField[K.FStore.Questionnaire.createdBy] as? String
              else { return nil }
        
        self.init(id: uid, title: title, description: description, createdBy: createdBy, questions: questions)
    }
}

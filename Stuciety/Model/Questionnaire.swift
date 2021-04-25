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
    var question: [Question]
}

extension Questionnaire {
    init?(uid: String, dictionaryField: [String: Any], document: DocumentSnapshot) {
        
        guard let title = dictionaryField[K.FStore.Questionnaire.title] as? String,
              let description = dictionaryField[K.FStore.Questionnaire.description] as? String,
              let createdBy = dictionaryField[K.FStore.Questionnaire.createdBy] as? String
              else { return nil }
        
        var questions: [Question] = []
        
        document.reference.collection(K.FStore.Questionnaire.childCollectionName).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Error getting documents: \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        if let question = Question(dictionary: doc.data()) {
                            questions.append(question)
                        }
                    }
                }
            }
        }
        
        self.init(id: uid, title: title, description: description, createdBy: createdBy, question: questions)
    }
}

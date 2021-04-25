//
//  Question.swift
//  Stuciety
//
//  Created by bryan colin on 4/24/21.
//

import Foundation

struct Question {
    var text: String
    var answer: String
}

extension Question {
    init?(dictionary: [String: Any]) {
        guard let text = dictionary[K.FStore.Questionnaire.Child.text] as? String else { return nil }
        self.init(text: text, answer: "")
    }
}
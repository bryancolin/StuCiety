//
//  Questionnaire.swift
//  Stuciety
//
//  Created by bryan colin on 4/23/21.
//

import Foundation

struct Questionnaire {
    var id: String
    var title: String
    var description: String
    var createdBy: String
    var question: [Question]
}

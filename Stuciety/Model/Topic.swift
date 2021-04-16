//
//  Topic.swift
//  Stuciety
//
//  Created by bryan colin on 3/27/21.
//

import Foundation
import UIKit

struct Topic {
    var featuredImage: UIImage
    var label: String
    
    static func fetchTopics() -> [[Topic]] {
        return [
            [Topic(featuredImage: #imageLiteral(resourceName: "COVID-19"), label: "COVID-19")],
            [
                Topic(featuredImage: #imageLiteral(resourceName: "Civil"), label: "Civil"),
                Topic(featuredImage: #imageLiteral(resourceName: "Software"), label: "Software")
            ]
        ]
    }
}

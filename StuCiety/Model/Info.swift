//
//  Info.swift
//  Stuciety
//
//  Created by bryan colin on 5/1/21.
//

import Foundation
import UIKit

struct Info {
    let title: String
    let description: String
    let image: UIImage
}

extension Info {
    static func fetchInfo() -> [Info] {
        return [
            Info(title: "COVID-19", description: "Learn How to Stay Safe", image: #imageLiteral(resourceName: "1")),
            Info(title: "Online Study", description: "Tips Learning from Home", image: #imageLiteral(resourceName: "2")),
        ]
    }
}

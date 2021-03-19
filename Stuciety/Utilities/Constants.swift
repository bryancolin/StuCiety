//
//  Constants.swift
//  Stuciety
//
//  Created by bryan colin on 3/17/21.
//

import Foundation

struct K {
    static let appName = "Stuciety"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToHome"
    static let loginSegue = "LoginToHome"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let lightBlue = "BrandLightBlue"
        static let lightGray = "BrandLightGray"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}

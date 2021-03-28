//
//  Constants.swift
//  Stuciety
//
//  Created by bryan colin on 3/17/21.
//

import Foundation

struct K {
    static let appName = "Stuciety"
    static let chatVC = "chatVC"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct Segue {
        static let register = "RegisterToHome"
        static let login = "LoginToHome"
        static let chat = "ToChat"
    }
    
    struct LoungeTable {
        static let cellIdentifier = "LoungeTableReusableCell"
        static let collectionCellIdentifier = "LoungeCollectionReusableCell"
    }
    
    struct CounselorTable {
        static let cellIdentifier = "CounselorTableReusableCell"
        static let collectionCellIdentifier = "CounselorCollectionReusableCell"
    }
    
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

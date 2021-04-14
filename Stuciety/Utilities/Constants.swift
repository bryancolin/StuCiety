//
//  Constants.swift
//  Stuciety
//
//  Created by bryan colin on 3/17/21.
//

import Foundation

struct K {
    static let appName = "Stuciety"
    
    struct Segue {
        static let register = "RegisterToProfile"
        static let profile = "ProfileToHome"
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
        
        struct Segue {
            static let details = "ToCounselorDetails"
        }
    }
    
    struct Room {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "MessageCell"
    }
    
    struct Settings {
        static let cellIdentifier = "SettingsReusableCell"
        
        struct Segue {
            static let account = "ToAccount"
        }
    }
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let lightBlue = "BrandLightBlue"
        static let lightGray = "BrandLightGray"
    }
    
    struct FStore {
        static let chatCollectionName = "rooms"
        static let childCollectionName = "messages"
        static let bodyField = "body"
        static let dateField = "createdAt"
        static let senderIdField = "senderId"
        static let senderNameField = "senderName"
    }
}

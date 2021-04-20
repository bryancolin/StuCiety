//
//  Constants.swift
//  Stuciety
//
//  Created by bryan colin on 3/17/21.
//

import Foundation
import SkeletonView

struct K {
    static let appName = "StuCiety"
    static let gradient = SkeletonGradient(baseColor: UIColor.clouds)
    
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
        
        struct Message {
            static let collectionName = "rooms"
            static let childCollectionName = "messages"
            
            static let idField = "id"
            static let bodyField = "body"
            static let dateField = "createdAt"
            static let senderIdField = "senderId"
            static let senderNameField = "senderName"
        }
        
        struct Counselor {
            static let collectionName = "counselors"

            static let id = "id"
            static let name = "displayName"
            static let email = "email"
            static let biography = "biography"
            static let area = "area"
            static let license = "license"
            static let photoURL = "photoURL"
        }
    }
}

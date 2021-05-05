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
        static let account = "ToAccount"
        static let info = "ToInfo"
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
            static let chat = "ToChatCounselor"
        }
    }
    
    struct Room {
        static let cellIdentifier = "ReusableCell"
        static let cellNibName = "MessageCell"
    }
    
    struct QuestionnaireCollection {
        static let cell1Identifier = "AccountReusableCell"
        static let cell2Identifier = "QuestionnaireReusableCell"
        
        struct Segue {
            static let start = "ToStart"
            static let question = "ToQuestion"
            static let finish = "ToFinish"
        }
    }
    
    struct Settings {
        static let cellIdentifier = "SettingsReusableCell"
    }
    
    struct AdditionalInfo {
        static let cellIdentifier = "InfoReusableCell"
    }
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let lightBlue = "BrandLightBlue"
        static let lightGray = "BrandLightGray"
    }
    
    struct FStore {
        
        struct Student {
            static let collectionName = "students"
            
            static let id = "id"
            static let name = "displayName"
            static let email = "email"
            static let photoURL = "photoURL"
            static let result = "result"
            static let questionnaires = "questionnaires"
        }
        
        struct Counselor {
            static let collectionName = "counselors"
            static let firstChildCollectionName = "chats"
            static let secondChildCollectionName = "messages"

            static let id = "id"
            static let name = "displayName"
            static let email = "email"
            static let biography = "biography"
            static let area = "area"
            static let license = "license"
            static let photoURL = "photoURL"
        }
        
        struct Message {
            static let collectionName = "rooms"
            static let childCollectionName = "messages"
            
            static let idField = "id"
            static let bodyField = "body"
            static let dateField = "createdAt"
            static let senderIdField = "senderId"
            static let senderNameField = "senderName"
        }

        struct Questionnaire {
            static let collectionName = "questionnaires"
            static let childCollectionName = "question"
            
            struct Child {
                static let text = "text"
                static let answer = "answer"
            }
            
            static let id = "id"
            static let title = "title"
            static let description = "description"
            static let createdBy = "createdBy"
            static let result = "result"
        }
    }
}

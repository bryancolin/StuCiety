//
//  Counselor.swift
//  Stuciety
//
//  Created by bryan colin on 4/13/21.
//

import Foundation

struct Counselor {
    var id: String
    var displayName: String
    var email: String
    var biography: String
    var area: [String]
    var license: [String]
    var photoURL: String
}

extension Counselor {
    init?(uid: String, dictionary: [String: Any]) {
        
        guard let name = dictionary[K.FStore.Counselor.name] as? String,
              let email = dictionary[K.FStore.Counselor.email] as? String,
              let biography = dictionary[K.FStore.Counselor.biography] as? String,
              let area = dictionary[K.FStore.Counselor.area] as? [String],
              let license = dictionary[K.FStore.Counselor.license] as? [String],
              let photoURL = dictionary[K.FStore.Counselor.photoURL] as? String else { return nil }
        
        self.init(id: uid, displayName: name, email: email, biography: biography, area: area, license: license, photoURL: photoURL)
    }
}
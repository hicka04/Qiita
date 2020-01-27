//
//  User.swift
//  Quiita
//
//  Created by hicka04 on 2020/01/25.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation

struct User: Decodable, Identifiable, Equatable {
    
    let id: ID
    let name: String
    let description: String?
    let location: String?
    let organization: String?
    let profileImageUrl: URL
}

extension User {
    
    struct ID: RawRepresentable, Decodable, Hashable, Equatable {
        
        let rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

#if DEBUG
extension User {
    
    static func dummy() -> User {
        User(id: ID(rawValue: "hicka04"),
             name: "Hikaru",
             description: nil,
             location: nil,
             organization: nil,
             profileImageUrl: URL(string: "https://qiita-image-store.s3.amazonaws.com/0/80832/profile-images/1540424506")!)
    }
}
#endif

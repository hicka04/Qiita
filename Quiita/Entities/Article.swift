//
//  Article.swift
//  Quiita
//
//  Created by hicka04 on 2020/01/25.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation

struct Article: Decodable, Identifiable, Equatable {
    
    let id: ID
    let title: String
    let tags: [Tag]
    let body: String
    let renderedBody: String
    let url: URL
    let createdAt: Date
    let updatedAt: Date
    let likesCount: Int
    let user: User
}

extension Article {
    
    struct ID: RawRepresentable, Decodable, Hashable, Equatable {
        
        let rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    struct Tag: Codable, Equatable {
        
        let name: String
    }
}

#if DEBUG
extension Article {
    
    static func dummy() -> Article {
        Article(id: ID(rawValue: "ArticleID"),
                title: "ArticleTitle",
                tags: [Tag(name: "iOS"), Tag(name: "Swift"), Tag(name: "Xcode")],
                body: "# h1\n## h2\n",
                renderedBody: "<h1>h1</h1><h2>h2</h2>",
                url: URL(string: "https://qiita.com")!,
                createdAt: Date(),
                updatedAt: Date(),
                likesCount: 100,
                user: User.dummy())
    }
}
#endif

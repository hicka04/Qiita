//
//  ArticleSearchHistoryRepository.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/27.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import Combine
import CoreData

protocol ArticleSearchHistoryRepository {
    
    func save(keyword: String)
    func histories() -> [ArticleSearchHistory]
}

final class ArticleSearchHistoryDataStore {
    
    private lazy var key = String(describing: self)
}

extension ArticleSearchHistoryDataStore: ArticleSearchHistoryRepository {
    
    func save(keyword: String) {
        var histories = self.histories()
        histories.append(.init(keyword: keyword))
        UserDefaults.standard.set(histories, forKey: key)
    }
    
    func histories() -> [ArticleSearchHistory] {
        UserDefaults.standard.array(forKey: key) ?? []
    }
}

extension UserDefaults {
    
    func set<Element: Codable>(_ array: [Element], forKey key: String) {
        let data = try? JSONEncoder().encode(array)
        self.set(data, forKey: key)
    }
    
    func array<Element: Codable>(forKey key: String) -> [Element]? {
        guard let data = self.data(forKey: key),
            let array = try? JSONDecoder().decode([Element].self, from: data) else {
                return nil
        }
        return array
        
    }
}

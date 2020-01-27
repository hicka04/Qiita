//
//  ArticleSearchResultStore.swift
//  Quiita
//
//  Created by hicka04 on 2020/01/18.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation
import Combine

final class ArticleSearchResultStore: ObservableObject {
    
    static let shared = ArticleSearchResultStore()
    
    @Published private(set) var articles: [Article] = []
    @Published var shownSearchErrorAlert = false
    
    private init(dispatcher: ArticleSearchResultDispatcher = .shared) {
        dispatcher.registor { [weak self] action in
            guard let self = self else { return }
            
            switch action {
            case .updateArticles(let articles):
                self.articles = articles
            case .catchError:
                self.shownSearchErrorAlert = true
            }
        }
    }
}

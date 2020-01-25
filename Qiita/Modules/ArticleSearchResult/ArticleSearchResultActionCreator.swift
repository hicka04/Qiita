//
//  ArticleSearchResultActionCreator.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/18.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation
import Combine

final class ArticleSearchResultActionCreator {
    
    private let onSearchSubject = PassthroughSubject<String, Never>()
    private let onSearchCancelSubject = PassthroughSubject<Void, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    private let dispatcher: ArticleSearchResultDispatcher = .shared
    
    init(articleSearchRepository: ArticleSearchRepository = ArticleSearchDataStore(),
         articleSearchHistoryRepository: ArticleSearchHistoryRepository = ArticleSearchHistoryDataStore()) {
        onSearchSubject
            .map { [articleSearchHistoryRepository] keyword in
                articleSearchHistoryRepository.save(keyword: keyword)
                return keyword
            }.flatMap { [articleSearchRepository] keyword in
                articleSearchRepository
                    .search(keyword: keyword)
                    .receive(on: DispatchQueue.main)
                    .catch { [weak self] error -> Empty<[Article], Never> in
                        self?.dispatcher.dispatch(.catchError)
                        return .init()
                    }
            }.sink { [weak self] articles in
                self?.dispatcher.dispatch(.updateArticles(articles))
            }.store(in: &cancellables)
        
        onSearchCancelSubject
            .sink { [weak self] _ in
                self?.dispatcher.dispatch(.updateArticles([]))
            }.store(in: &cancellables)
    }
}

extension ArticleSearchResultActionCreator {
    
    func onSearch(keyword: String) {
        onSearchSubject.send(keyword)
    }
    
    func onSearchCancel() {
        onSearchCancelSubject.send()
    }
}

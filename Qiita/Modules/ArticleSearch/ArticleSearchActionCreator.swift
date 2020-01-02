//
//  ArticleSearchActionCreator.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/24.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import Combine
import QiitaAPIClient

final class ArticleSearchActionCreator {
    
    private let dispatcher: ArticleSearchDispatcher = .shared
    private let qiitaAPIClient: QiitaAPIRequestable
    private let articleSearchHistoryRepository: ArticleSearchHistoryRepository
    
    private var cancellables: Set<AnyCancellable> = []
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    private let searchCancelSubject = PassthroughSubject<Void, Never>()
    
    init(qiitaAPIClient: QiitaAPIRequestable = QiitaAPIClient(),
         articleSearchHistoryRepository: ArticleSearchHistoryRepository = ArticleSearchHistoryDataStore()) {
        self.qiitaAPIClient = qiitaAPIClient
        self.articleSearchHistoryRepository = articleSearchHistoryRepository
        
        onAppearSubject
            .map { [articleSearchHistoryRepository] in
                articleSearchHistoryRepository.histories()
            }.sink { histories in
                self.dispatcher.dispatch(.updateHistories(histories))
            }.store(in: &cancellables)
        
        searchTextSubject
            .sink { text in
                self.dispatcher.dispatch(.updateSearchKeyword(text))
            }.store(in: &cancellables)
        
        searchTextSubject
            .map { text in
                articleSearchHistoryRepository.save(keyword: text)
                return articleSearchHistoryRepository.histories()
            }.sink { histories in
                self.dispatcher.dispatch(.updateHistories(histories))
            }.store(in: &cancellables)
        
        searchTextSubject
            .flatMap { [qiitaAPIClient] text in
                qiitaAPIClient
                    .send(QiitaAPI.SearchArticles(query: text))
                    .receive(on: DispatchQueue.main)
                    .catch { [weak self] error -> Empty<[Article], Never> in
                        self?.dispatcher.dispatch(.catchError(error))
                        return .init()
                    }
            }.sink { [weak self] articles in
                self?.dispatcher.dispatch(.updateArticles(articles))
            }.store(in: &cancellables)
        
        searchCancelSubject
            .sink { [weak self] _ in
                self?.dispatcher.dispatch(.searchCanceled)
            }.store(in: &cancellables)
    }
}

extension ArticleSearchActionCreator {
    
    func onAppear() {
        onAppearSubject.send()
    }
    
    func searchBarSearchButtonClicked(text: String) {
        searchTextSubject.send(text)
    }
    
    func searchBarCancelButtonClicked() {
        searchCancelSubject.send()
    }
    
    func didSelectSearchHistoryCell(history: ArticleSearchHistory) {
        searchTextSubject.send(history.keyword)
    }
}

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
    
    private var cancellables: Set<AnyCancellable> = []
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    private let searchTextSubject = PassthroughSubject<String, Never>()
    
    init(qiitaAPIClient: QiitaAPIRequestable = QiitaAPIClient()) {
        self.qiitaAPIClient = qiitaAPIClient
        
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
    }
}

extension ArticleSearchActionCreator {
    
    func onAppear() {
        onAppearSubject.send()
    }
    
    func searchBarSearchButtonClicked(text: String) {
        searchTextSubject.send(text)
    }
}

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
    
    init(qiitaAPIClient: QiitaAPIRequestable = QiitaAPIClient()) {
        self.qiitaAPIClient = qiitaAPIClient
        
        onAppearSubject
            .flatMap { [qiitaAPIClient] _ in
                qiitaAPIClient
                    .send(QiitaAPI.SearchArticles())
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
}

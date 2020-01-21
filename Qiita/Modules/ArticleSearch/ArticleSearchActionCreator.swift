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
    
    private var cancellables: Set<AnyCancellable> = []
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    
    init(articleSearchHistoryRepository: ArticleSearchHistoryRepository = ArticleSearchHistoryDataStore()) {
        onAppearSubject
            .map { [articleSearchHistoryRepository] in
                articleSearchHistoryRepository.histories()
            }.sink { histories in
                self.dispatcher.dispatch(.updateHistories(histories))
            }.store(in: &cancellables)
    }
}

extension ArticleSearchActionCreator {
    
    func onAppear() {
        onAppearSubject.send()
    }
}

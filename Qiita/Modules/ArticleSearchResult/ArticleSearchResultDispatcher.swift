//
//  ArticleSearchResultDispatcher.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/18.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation
import Combine

final class ArticleSearchResultDispatcher {
    
    static let shared = ArticleSearchResultDispatcher()
    
    private let actionSubject = PassthroughSubject<ArticleSearchResultAction, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {}
    
    func registor(callback: @escaping (ArticleSearchResultAction) -> Void) {
        actionSubject
            .sink(receiveValue: callback)
            .store(in: &cancellables)
    }
    
    func dispatch(_ action: ArticleSearchResultAction) {
        actionSubject.send(action)
    }
}

//
//  ArticleSearchDispatcher.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/24.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import Combine

final class ArticleSearchDispatcher {
    
    static let shared = ArticleSearchDispatcher()
    
    private let actionSubject = PassthroughSubject<ArticleSearchAction, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    private init() {}
    
    func registor(callback: @escaping (ArticleSearchAction) -> Void) {
        actionSubject
            .sink(receiveValue: callback)
            .store(in: &cancellables)
    }
    
    func dispatch(_ action: ArticleSearchAction) {
        actionSubject.send(action)
    }
}

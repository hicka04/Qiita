//
//  ArticleSearchStore.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/24.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import Combine
import QiitaAPIClient

final class ArticleSearchStore: ObservableObject {
    
    static let shared = ArticleSearchStore()
    
    @Published private(set) var histories: [ArticleSearchHistory] = []
    @Published var shownSearchErrorAlert = false
    
    var cancellables: Set<AnyCancellable> = []
    
    private init(dispatcher: ArticleSearchDispatcher = .shared) {
        dispatcher.registor { [weak self] action in
            guard let self = self else { return }
            
            switch action {
            case .updateHistories(let histories):
                self.histories = histories
            case .catchError:
                self.shownSearchErrorAlert = true
            }
        }
    }
}

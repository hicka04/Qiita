//
//  ArticleSearchRepository.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/25.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation
import Combine
import QiitaAPIClient

protocol ArticleSearchRepository: AnyObject {
    
    func search(keyword: String) -> AnyPublisher<[Article], ArticleSearchError>
}

enum ArticleSearchError: Error {
    
    case apiError
    case parseError
}

final class ArticleSearchDataStore {
    
    private let qiitaAPIClient: QiitaAPIRequestable
    
    init(qiitaAPIClient: QiitaAPIRequestable = QiitaAPIClient()) {
        self.qiitaAPIClient = qiitaAPIClient
    }
}

extension ArticleSearchDataStore: ArticleSearchRepository {
    
    func search(keyword: String) -> AnyPublisher<[Article], ArticleSearchError> {
        qiitaAPIClient
            .send(QiitaAPI.SearchArticles(query: keyword))
            .mapError { _ in ArticleSearchError.apiError }
            .encode(encoder: JSONEncoder())
            .decode(type: [Article].self, decoder: JSONDecoder())
            .mapError{ _ in ArticleSearchError.parseError }
            .eraseToAnyPublisher()
    }
}

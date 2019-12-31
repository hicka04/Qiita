//
//  ArticleSearchAction.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/24.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import QiitaAPIClient

enum ArticleSearchAction {
    
    case updateSearchKeyword(_ keyword: String)
    case searchCanceled
    case updateHistories(_ histories: [ArticleSearchHistory])
    case updateArticles(_ articles: [Article])
    case catchError(_ error: QiitaClientError)
}

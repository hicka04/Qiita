//
//  ArticleSearchResultAction.swift
//  Quiita
//
//  Created by hicka04 on 2020/01/18.
//  Copyright © 2020 hicka04. All rights reserved.
//

import Foundation

enum ArticleSearchResultAction {
    
    case updateArticles(_ articles: [Article])
    case catchError
}

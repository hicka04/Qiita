//
//  ArticleSearchView.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/24.
//  Copyright © 2019 hicka04. All rights reserved.
//

import SwiftUI

struct ArticleSearchView: View {
    
    @ObservedObject private var store: ArticleSearchStore = .shared
    
    private let actionCreator = ArticleSearchActionCreator()
    
    var body: some View {
        NavigationView {
            List(store.articles) { article in
                Text("\(article.title)")
            }
            .alert(isPresented: $store.isShownSearchErrorAlert) { () -> Alert in
                Alert(title: Text("検索エラー"),
                      message: Text("エラーが発生しました。\n時間をおいてから再度検索してください。"))
            }
            .navigationBarTitle("Search", displayMode: .inline)
        }
        .onAppear {
            self.actionCreator.onAppear()
        }
    }
}

struct SearchArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleSearchView()
    }
}

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
    @State private var searchText = ""
    @State private var showsCancelButton = false
    
    private let actionCreator = ArticleSearchActionCreator()
    
    var body: some View {
        NavigationSearchBar(
            placeholder: "Enter search keywords",
            text: $searchText,
            eventHandler: { event in
                switch event {
                case .searchButtonClicked(let text):
                    self.actionCreator.searchBarSearchButtonClicked(text: text)
                default:
                    break
                }
            }
        ) {
            ArticleSearchResultsView()
                .navigationBarTitle("Search")
        }.onAppear {
            self.actionCreator.onAppear()
        }
    }
}

private struct ArticleSearchResultsView: View {
    
    @ObservedObject private var store: ArticleSearchStore = .shared
    
    var body: some View {
        List(store.articles) { article in
            Text(article.title)
        }.alert(isPresented: $store.isShownSearchErrorAlert, content: { () -> Alert in
            Alert(title: Text("Error"))
        })
    }
}

#if DEBUG
struct ArticleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleSearchView()
    }
}
#endif

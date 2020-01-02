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
                case .cancelButtonClicked:
                    self.actionCreator.searchBarCancelButtonClicked()
                default:
                    break
                }
            }
        ) {
            ZStack {
                ArticleSearchHistoryView()
                if store.shownSearchResultView {
                    ArticleSearchResultsView()
                }
            }
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
        }.alert(isPresented: $store.shownSearchErrorAlert, content: { () -> Alert in
            Alert(title: Text("Error"))
        })
    }
}

private struct ArticleSearchHistoryView: View {
    
    @ObservedObject private var store: ArticleSearchStore = .shared
    
    private let actionCreator = ArticleSearchActionCreator()
    
    var body: some View {
        List {
            Text("History")
                .font(.headline)
                .fontWeight(.bold)
            ForEach(store.histories, id: \.keyword) { history in
                Button(action: {
                    self.actionCreator.didSelectSearchHistoryCell(history: history)
                }) {
                    Text(history.keyword)
                        .foregroundColor(Color.blue)
                }
            }
        }
    }
}

#if DEBUG
struct ArticleSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleSearchView()
    }
}
#endif

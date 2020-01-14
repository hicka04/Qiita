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
    @State private var keyword = ""
    @State private var shownResultView = false
    
    private let actionCreator = ArticleSearchActionCreator()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(placeholder: "Enter search keywords", text: $keyword)
                    .onSearch { keyword in
                        self.shownResultView = true
                        self.actionCreator.onSearch(keyword: keyword)
                    }.onCancel {
                        self.shownResultView = false
                        self.actionCreator.onSearchCancel()
                    }
                ZStack {
                    ArticleSearchHistoryView(keyword: $keyword,
                                             shownResultView: $shownResultView)
                    if shownResultView {
                        ArticleSearchResultsView()
                    }
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
            NavigationLink(destination: Text(article.title)) {
                Text(article.title)
            }
        }.alert(isPresented: $store.shownSearchErrorAlert) {
            Alert(title: Text("Error"))
        }
    }
}

private struct ArticleSearchHistoryView: View {
    
    @ObservedObject private var store: ArticleSearchStore = .shared
    @Binding var keyword: String
    @Binding var shownResultView: Bool
    
    private let actionCreator = ArticleSearchActionCreator()
    
    var body: some View {
        List {
            Text("History")
                .font(.headline)
                .fontWeight(.bold)
            ForEach(store.histories, id: \.keyword) { history in
                Button(action: {
                    self.keyword = history.keyword
                    self.shownResultView = true
                    self.actionCreator.onSelectSearchHistoryCell(history: history)
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

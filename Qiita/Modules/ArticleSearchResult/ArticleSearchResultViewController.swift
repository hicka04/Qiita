//
//  ArticleSearchResultViewController.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/17.
//  Copyright © 2020 hicka04. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import QiitaAPIClient

final class ArticleSearchResultViewController: UITableViewController {
    
    private var store: ArticleSearchResultStore = .shared
    private let actionCreator = ArticleSearchResultActionCreator()
    
    private var articles: [Article] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var shownSearchErrorAlert = false {
        didSet {
            guard shownSearchErrorAlert else { return }
            
            let alert = UIAlertController(title: "Error",
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close",
                                          style: .default,
                                          handler: nil))
            present(alert, animated: true) { [weak self] in
                self?.store.shownSearchErrorAlert = false
            }
        }
    }
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        store.$articles
            .assign(to: \.articles, on: self)
            .store(in: &cancellables)
    }
}

extension ArticleSearchResultViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = articles[indexPath.row].title
        return cell
    }
}

extension ArticleSearchResultViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchKeyword = searchBar.text else { return }
        actionCreator.onSearch(keyword: searchKeyword)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        actionCreator.onSearchCancel()
    }
}

#if DEBUG
struct ArticleSearchResultViewController_Previews: PreviewProvider {
    
    struct ArticleSearchResultView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> ArticleSearchResultViewController {
            ArticleSearchResultViewController()
        }
        
        func updateUIViewController(_ uiViewController: ArticleSearchResultViewController, context: Context) {
            
        }
    }
    
    static var previews: some View {
        ArticleSearchResultView()
    }
}
#endif

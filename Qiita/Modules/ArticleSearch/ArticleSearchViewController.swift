//
//  ArticleSearchViewController.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/24.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class ArticleSearchViewController: UITableViewController {
    
    private var store: ArticleSearchStore = .shared
    private let actionCreator = ArticleSearchActionCreator()
    private var histories: [ArticleSearchHistory] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    
    let searchResultViewController = ArticleSearchResultViewController()
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.delegate = searchResultViewController
        searchController.searchBar.placeholder = "Enter search keywords"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "header")
        
        store.$histories
            .assign(to: \.histories, on: self)
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        actionCreator.onAppear()
    }
}

extension ArticleSearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        histories.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        header?.textLabel?.text = "History"
        header?.contentView.backgroundColor = .systemBackground
        return header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = histories[indexPath.row].keyword
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = histories[indexPath.row].keyword
        searchController.isActive = true
        searchController.searchBar.text = keyword
        searchResultViewController.searchBarSearchButtonClicked(searchController.searchBar)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#if DEBUG
struct ArticleSearchViewController_Previews: PreviewProvider {
    
    struct ArticleSearchView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ArticleSearchViewController_Previews.ArticleSearchView>) -> UINavigationController {
            UINavigationController(rootViewController: ArticleSearchViewController())
        }
        
        func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<ArticleSearchViewController_Previews.ArticleSearchView>) {
            
        }
    }
    
    static var previews: some View {
        ArticleSearchView()
    }
}
#endif

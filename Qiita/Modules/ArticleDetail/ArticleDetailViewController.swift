//
//  ArticleDetailViewController.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/22.
//  Copyright © 2020 hicka04. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import CustomViews

class ArticleDetailViewController: UIViewController {
    
    private let article: Article
    
    lazy var scrollStackView: ScrollStackView = {
        let scrollStackView = ScrollStackView(axis: .vertical,
                                              spacing: 16,
                                              padding: (16, 16, 16, 16))
        scrollStackView.views = [
            TitleLabel(text: article.title),
            UserInfoView(user: article.user),
            ArticleBodyView(article: article)
        ]
        scrollStackView.translatesAutoresizingMaskIntoConstraints = false
        return scrollStackView
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
       
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(scrollStackView)
        NSLayoutConstraint.activate([
            scrollStackView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollStackView
            .publisher(for: \.contentOffset)
            .map { $0.y <= 0 }
            .sink { [weak self] isTop in
                self?.navigationController?.navigationBar.setBackgroundImage(isTop ? UIImage() : nil, for: .default)
                self?.navigationController?.navigationBar.shadowImage = isTop ? UIImage() : nil
                self?.navigationController?.view.backgroundColor = isTop ? .clear : .systemBackground
                self?.navigationItem.title = isTop ? nil : self?.article.title
            }.store(in: &cancellables)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.view.backgroundColor = .systemBackground
    }
}

#if DEBUG
struct ArticleDetailViewController_Previews: PreviewProvider {
    
    struct ArticleDetailView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: Context) -> UINavigationController {
            UINavigationController(rootViewController: ArticleDetailViewController(article: Article.dummy()))
        }
        
        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
            
        }
    }
    
    static var previews: some View {
        ArticleDetailView()
    }
}
#endif

//
//  ArticleBodyView.swift
//  Quiita
//
//  Created by hicka04 on 2020/01/23.
//  Copyright © 2020 hicka04. All rights reserved.
//

import UIKit
import SwiftUI
import WebKit

// TODO: Markdown Rendering
extension ArticleDetailViewController {
    
    final class ArticleBodyView: UILabel {
        
        private let article: Article
        
        init(article: Article) {
            self.article = article
            super.init(frame: .zero)
            
            text = article.body
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

#if DEBUG
struct ArticleBodyView_Previews: PreviewProvider {
    
    struct PreviewArticleBodyView: UIViewRepresentable {
        
        func makeUIView(context: Context) -> ArticleDetailViewController.ArticleBodyView {
            ArticleDetailViewController.ArticleBodyView(article: Article.dummy())
        }
        
        func updateUIView(_ uiView: ArticleDetailViewController.ArticleBodyView, context: Context) {
            
        }
    }
    
    static var previews: some View {
        PreviewArticleBodyView()
    }
}
#endif

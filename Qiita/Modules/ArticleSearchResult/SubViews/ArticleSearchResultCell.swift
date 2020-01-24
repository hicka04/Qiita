//
//  ArticleSearchResultCell.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/24.
//  Copyright © 2020 hicka04. All rights reserved.
//

import UIKit
import QiitaAPIClient

class ArticleSearchResultCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var userIdLabel: UILabel!
    
    func set(article: Article) {
        titleLabel.text = article.title
        profileImageView.loadImage(from: article.user.profileImageUrl)
        userIdLabel.text = "@\(article.user.id.rawValue)"
    }
}

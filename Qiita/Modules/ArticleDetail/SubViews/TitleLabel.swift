//
//  TitleLabel.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/22.
//  Copyright © 2020 hicka04. All rights reserved.
//

import UIKit

extension ArticleDetailViewController {
    
    final class TitleLabel: UILabel {

        init(text: String) {
            super.init(frame: .zero)
            self.text = text
            numberOfLines = 0
            lineBreakMode = .byWordWrapping
            font = .preferredFont(for: .largeTitle, weight: .bold)
            adjustsFontForContentSizeCategory = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

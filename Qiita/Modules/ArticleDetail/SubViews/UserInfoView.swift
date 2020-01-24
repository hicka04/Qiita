//
//  UserInfoView.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/23.
//  Copyright © 2020 hicka04. All rights reserved.
//

import SwiftUI
import QiitaAPIClient

extension ArticleDetailViewController {
    
    final class UserInfoView: UIView {
        
        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                ProfileImageView(profileImageUrl: user.profileImageUrl),
                UserIdLabel(userId: user.id)
            ])
            stackView.alignment = .center
            stackView.spacing = 16
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        
        private let user: User
        
        init(user: User) {
            self.user = user
            super.init(frame: .zero)
            
            addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: self.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension ArticleDetailViewController.UserInfoView {
    
    private final class ProfileImageView: UIImageView {
        
        init(profileImageUrl: URL) {
            super.init(frame: .zero)
            loadImage(from: profileImageUrl)
            translatesAutoresizingMaskIntoConstraints = false
            widthAnchor.constraint(equalToConstant: 36).isActive = true
            heightAnchor.constraint(equalToConstant: 36).isActive = true
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private final class UserIdLabel: UILabel {
        
        init(userId: User.ID) {
            super.init(frame: .zero)
            text = "@\(userId.rawValue)"
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}


#if DEBUG
struct UserInfoView_Previews: PreviewProvider {
    
    struct PreviewUserInfoView: UIViewRepresentable {
        
        func makeUIView(context: Context) -> ArticleDetailViewController.UserInfoView {
            ArticleDetailViewController.UserInfoView(user: User.dummy())
        }
        
        func updateUIView(_ uiView: ArticleDetailViewController.UserInfoView, context: Context) {
            
        }
    }
    
    static var previews: some View {
        PreviewUserInfoView()
    }
}
#endif

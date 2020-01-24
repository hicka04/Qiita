//
//  ScrollStackView.swift
//  Qiita
//
//  Created by hicka04 on 2020/01/23.
//  Copyright © 2020 hicka04. All rights reserved.
//

import UIKit
import SwiftUI

final public class ScrollStackView: UIScrollView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    public var views: [UIView] = [] {
        didSet {
            views.forEach {
                stackView.addArrangedSubview($0)
            }
        }
    }
    private let axis: NSLayoutConstraint.Axis
    private let spacing: CGFloat
    
    public init(axis: NSLayoutConstraint.Axis,
                spacing: CGFloat = 0,
                padding: Padding = (0, 0, 0, 0)) {
        self.axis = axis
        self.spacing = spacing
        super.init(frame: .zero)
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding.top),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.leading),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding.trailing),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding.bottom)
        ])
        switch axis {
        case .horizontal:
            stackView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -(padding.top+padding.bottom)).isActive = true
        case .vertical:
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -(padding.leading+padding.trailing)).isActive = true
        @unknown default:
            break
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScrollStackView {
    
    public typealias Padding = (top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat)
}

#if DEBUG
struct ScrollStackView_Previews: PreviewProvider {
    
    struct PreviewScrollStackView: UIViewRepresentable {
        
        let views: [UIView]
        let axis: NSLayoutConstraint.Axis
        let spacing: CGFloat
        let padding: ScrollStackView.Padding
        
        func makeUIView(context: Context) -> ScrollStackView {
            let scrollStackView = ScrollStackView(axis: axis,
                                                  spacing: spacing,
                                                  padding: padding)
            scrollStackView.views = views
            return scrollStackView
        }
        
        func updateUIView(_ uiView: ScrollStackView, context: Context) {
            
        }
    }
    
    final class Label: UILabel {
        
        init(text: String) {
            super.init(frame: .zero)
            self.text = text
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    static var previews: some View {
        let views = (0..<50).map { Label(text: "label\($0)") }
        return Group {
            PreviewScrollStackView(views: views, axis: .horizontal, spacing: 8, padding: (8, 8, 8, 8))
            PreviewScrollStackView(views: views, axis: .vertical, spacing: 8, padding: (8, 8, 8, 8))
        }
    }
}
#endif

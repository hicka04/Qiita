//
//  SearchBar.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/27.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    let placeholder: String
    @Binding var text: String
    fileprivate let onEditingAction: (() -> Void)?
    fileprivate let onSearchAction: ((String) -> Void)?
    fileprivate let onCancelAction: (() -> Void)?
    
    init(placeholder: String,
         text: Binding<String>) {
        self.init(placeholder: placeholder,
                  text: text,
                  onEditingAction: nil,
                  onSearchAction: nil,
                  onCancelAction: nil)
    }
    
    fileprivate init(placeholder: String,
                     text: Binding<String>,
                     onEditingAction: (() -> Void)?,
                     onSearchAction: ((String) -> Void)?,
                     onCancelAction: (() -> Void)?) {
        self.placeholder = placeholder
        _text = text
        self.onEditingAction = onEditingAction
        self.onSearchAction = onSearchAction
        self.onCancelAction = onCancelAction
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.clearButtonMode = .whileEditing
        
        searchBar.delegate = context.coordinator
        
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        searchBar.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text,
                    onEditingAction: onEditingAction,
                    onSearchAction: onSearchAction,
                    onCancelAction: onCancelAction)
    }
}

extension SearchBar {
    
    func onEditing(perform action: @escaping () -> Void) -> SearchBar {
        SearchBar(placeholder: placeholder,
                  text: $text,
                  onEditingAction: action,
                  onSearchAction: onSearchAction,
                  onCancelAction: onCancelAction)
    }
    
    func onSearch(perform action: @escaping (String) -> Void) -> SearchBar {
        SearchBar(placeholder: placeholder,
                  text: $text,
                  onEditingAction: onEditingAction,
                  onSearchAction: action,
                  onCancelAction: onCancelAction)
    }
    
    func onCancel(perform action: @escaping () -> Void) -> SearchBar {
        SearchBar(placeholder: placeholder,
                  text: $text,
                  onEditingAction: onEditingAction,
                  onSearchAction: onSearchAction,
                  onCancelAction: action)
    }
}

extension SearchBar {
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        var onEditingAction: (() -> Void)?
        var onSearchAction: ((String) -> Void)?
        var onCancelAction: (() -> Void)?
        
        init(text: Binding<String>,
             onEditingAction: (() -> Void)?,
             onSearchAction: ((String) -> Void)?,
             onCancelAction: (() -> Void)?) {
            _text = text
            self.onEditingAction = onEditingAction
            self.onSearchAction = onSearchAction
            self.onCancelAction = onCancelAction
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
            onEditingAction?()
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(false)
            onSearchAction?(text)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchBar.endEditing(false)
            onCancelAction?()
        }
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchBar(placeholder: "placeholder",
                  text: .constant("text"))
            .previewLayout(.sizeThatFits)
    }
}
#endif

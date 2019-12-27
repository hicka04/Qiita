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
    let searchButtonClicked: (String) -> Void
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }
    
    func updateUIView(_ searchBar: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        searchBar.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, searchButtonClicked: searchButtonClicked)
    }
}

extension SearchBar {
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        let searchButtonClicked: (String) -> Void
        
        init(text: Binding<String>,
             searchButtonClicked: @escaping (String) -> Void) {
            _text = text
            self.searchButtonClicked = searchButtonClicked
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchButtonClicked(text)
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            text = ""
            searchBar.endEditing(false)
        }
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchBar(placeholder: "hoge", text: .constant("keyword")) { _ in }
    }
}
#endif

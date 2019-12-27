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
    let eventHandler: (Event) -> Void
    
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
                    eventHandler: eventHandler)
    }
}

extension SearchBar {
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        let eventHandler: (Event) -> Void
        
        init(text: Binding<String>,
             eventHandler: @escaping (Event) -> Void) {
            _text = text
            self.eventHandler = eventHandler
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
            eventHandler(.beginEditing)
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(false)
            eventHandler(.searchButtonClicked(text: text))
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchBar.endEditing(false)
            eventHandler(.cancelButtonClicked)
        }
    }
}

extension SearchBar {
    
    enum Event {
        case beginEditing
        case searchButtonClicked(text: String)
        case cancelButtonClicked
    }
}

#if DEBUG
struct SearchBar_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchBar(placeholder: "hoge",
                  text: .constant("keyword"),
                  eventHandler: { _ in })
    }
}
#endif

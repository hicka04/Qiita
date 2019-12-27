//
//  NavigationSearchBar.swift
//  Qiita
//
//  Created by hicka04 on 2019/12/27.
//  Copyright © 2019 hicka04. All rights reserved.
//

import SwiftUI

struct NavigationSearchBar<Content: View>: View {
    
    private let content: Content
    let placeholder: String
    @Binding var text: String
    let eventHandler: (SearchBar.Event) -> Void
    
    @State private var isHiddenNavigationBar = false
    
    init(placeholder: String,
         text: Binding<String>,
         eventHandler: @escaping (SearchBar.Event) -> Void,
         @ViewBuilder content: () -> Content) {
        self.placeholder = placeholder
        _text = text
        self.eventHandler = eventHandler
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(
                    placeholder: placeholder,
                    text: $text) { event in
                        switch event {
                        case .beginEditing:
                            self.isHiddenNavigationBar = true
                        case .cancelButtonClicked:
                            self.isHiddenNavigationBar = false
                        default:
                            break
                        }
                        self.eventHandler(event)
                        
                }.padding(.horizontal, 8)
                content
            }.navigationBarHidden(isHiddenNavigationBar)
        }
    }
}

#if DEBUG
struct NavigationSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSearchBar(
            placeholder: "placeholder",
            text: .constant("Swift"),
            eventHandler: { _ in }) {
                List {
                    Text("Hello World")
                }.navigationBarTitle("NavigationTitle")
        }
    }
}
#endif

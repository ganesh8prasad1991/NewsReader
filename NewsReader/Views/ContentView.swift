//
//  ContentView.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NewsView()
                .tabItem {
                    Label(
                        "News",
                        systemImage: "newspaper.circle"
                    )
                }
            
            BookmarkView()
                .tabItem {
                    Label(
                        "Bookmark",
                        systemImage: "bookmark.circle"
                    )
                }
        }
    }
}

#Preview {
    ContentView()
}

//
//  BookmarkView.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import SwiftUI

struct BookmarkView: View {
    @State private var viewModel = BookmarkViewModel()
    
    var body: some View {
        NavigationView {
            // Vertical news view
            List {
                ForEach(viewModel.bookmarks) { bookmark in
                    NavigationLink(
                        destination: NewsArticleDetailView(article: bookmark)
                    ) {
                        VStack {
                            NewsArticleListItemView(article: bookmark)
                                .padding()
                            
                            Divider()
                        }
                    } //: NAVIGATIONLINK
                } //: LOOP
            }
            .navigationTitle("Bookmark")
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                if viewModel.bookmarks.isEmpty {
                    ContentUnavailableView {
                        Label(
                            "Please add your favorite news article into Bookmark!",
                            systemImage: "bookmark.fill"
                        )
                    }
                }
            }
            .task {
                await viewModel.getBookmarkArticles()
            }
        }
    }
}

#Preview {
    BookmarkView()
}

//
//  NewsView.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import SwiftUI

struct NewsView: View {
    @State private var viewModel = NewsViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if !viewModel.isLoaded {
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: .accentColor)
                        )
                } else {
                    List {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(
                                destination: NewsArticleDetailView(article: article)
                            ) {
                                
                                NewsArticleListItemView(article: article)
                            } //: NAVIGATIONLINK
                        } //: LOOP
                    }
                }
            } //: GROUP
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                if viewModel.articles.isEmpty {
                    ContentUnavailableView {
                        Label(
                            "Please check your internet connection and try again!",
                            systemImage: "doc.richtext.fill"
                        )
                    }
                }
            }
            .task {
                do {
                    if viewModel.articles.isEmpty { // checks for unnecessary api calls
                        try await viewModel.getArticles()
                    }
                } catch {
                    debugPrint(error.localizedDescription)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.message))
            }
        }
    }
}

#Preview {
    NewsView()
}

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
                    ScrollView(.vertical) {
                        VStack {
                            horizontalScrollingCategory
                            
                            // Vertical news view
                            ForEach(viewModel.articles) { article in
                                NavigationLink(
                                    destination: NewsArticleDetailView(article: article)
                                ) {
                                    VStack {
                                        NewsArticleListItemView(article: article)
                                            .padding()
                                        
                                        Divider()
                                    }
                                } //: NAVIGATIONLINK
                            } //: LOOP
                        }
                    }
                    .padding()
                }
            } //: GROUP
            .navigationTitle("News")
            .navigationBarTitleDisplayMode(.large)
            .overlay {
                if viewModel.articles.isEmpty {
                    ContentUnavailableView {
                        Label(
                            "Please select different category!",
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
    
    var horizontalScrollingCategory: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                ForEach(viewModel.categories, id: \.id) { categoryModel in
                    Button {
                        Task {
                            do {
                                try await viewModel.didSelectCategory(categoryModel: categoryModel)
                            } catch {
                                debugPrint(error.localizedDescription)
                            }
                        }
                    } label: {
                        Text(categoryModel.category.rawValue)
                            .padding()
                            .foregroundColor(categoryModel.isSelected ? .white : .black)
                            .background(categoryModel.isSelected ? .gray : .white)
                            .cornerRadius(.infinity)
                            .lineLimit(1)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(.black, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
}

#Preview {
    NewsView()
}

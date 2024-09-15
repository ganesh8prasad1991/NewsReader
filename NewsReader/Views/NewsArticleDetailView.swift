//
//  NewsArticleDetailView.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import SwiftUI

struct NewsArticleDetailView: View {
    let article: Article
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                // TITLE
                Text(article.title ?? "")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                // IMAGE
                if let urlToImage = article.urlToImage {
                    NewsCacheAsyncImage(url: urlToImage)
                        .scaledToFill()
                }
                
                // DESCRIPTION
                Text("Description".uppercased())
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                    .foregroundColor(.primary)
                    .background(
                        Color.accentColor
                            .frame(height: 6)
                            .offset(y: 24)
                    )
                
                // EXPLANATION
                Text(article.content ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .padding(.horizontal)
            } //: VSTACK
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        } //: SCROLL
    }
}

#Preview {
    let article = Article(
        source: nil,
        author: "Rohan Nadkarni",
        title: "Dolphins QB Tua Tagovailoa sustains concussion in 31-10 loss to Bills - NBC News",
        description: "Miami Dolphins quarterback Tua Tagovailoa left Thursday’s game against the Buffalo Bills with a concussion, the team announced.",
        urlToImage: URL(string: "https://apod.nasa.gov/apod/image/2405/STScI-WASP43b_temperature.png"),
        publishedAt: "2024-09-13T12:04:00Z",
        content: "Miami Dolphins quarterback Tua Tagovailoa left Thursdays game against the Buffalo Bills with a concussion, the team announced.\\r\\nAfter a fourth-down run in the third quarter, Tagovailoa collided head-… [+3457 chars]"
    )
    
    return NewsArticleDetailView(article: article)
}

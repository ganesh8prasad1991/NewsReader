//
//  NewsArticleListItemView.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import SwiftUI

struct NewsArticleListItemView: View {
    let article: Article
    @State private var image: Image? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if let image {
                // CACHED IMAGE
                HStack {
                    image
                        .resizable()
                        .scaledToFill()
                }
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
            } else {
                if let urlToImage = article.urlToImage {
                    NewsCacheAsyncImage(url: urlToImage)
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }
            } //: ASYNCIMAGE
            
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title ?? "")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .lineLimit(1)
                    .foregroundColor(.black)
                
                Text(article.description ?? "")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .padding(.trailing, 8)
                
                // Bookmark
                HStack {
                    Spacer()
                    
                    Button {
                        print("HI there")
                    } label: {
                        Image(systemName: "bookmark")
                            .padding()
                            .foregroundColor(.white)
                            .background(.gray)
                            .cornerRadius(.infinity)
                            .overlay( /// apply a rounded border
                                RoundedRectangle(cornerRadius: .infinity)
                                    .stroke(.black, lineWidth: 1)
                            )
                    }
                    
                }
            } //: VSTACK
        } //: HSTACK
        .onAppear {
            if let urlToImage = article.urlToImage,
               let cachedImage = ImageCache[urlToImage] {
                self.image = cachedImage
            }
        }
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
    return NewsArticleListItemView(article: article)
}

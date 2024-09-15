//
//  NewsCacheAsyncImage.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import SwiftUI

struct NewsCacheAsyncImage: View {
    let url: URL
    
    var body: some View {
        CacheAsyncImage(
            url: url
        ) { phase in
            switch phase {
            case .success(let image):
                HStack {
                    image
                        .resizable()
                        .scaledToFill()
                }
            case .failure(_):
                Image(systemName: "questionmark")
            case .empty:
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                }
            @unknown default:
                // AsyncImagePhase is not marked as @frozen.
                // We need to support new cases in the future.
                Image(systemName: "questionmark")
            }
        }
    }
}

#Preview {
    NewsCacheAsyncImage(
        url: URL(string: "https://apod.nasa.gov/apod/image/2405/STScI-WASP43b_temperature.png")!
    )
}

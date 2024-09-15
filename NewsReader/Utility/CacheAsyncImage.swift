//
//  CacheAsyncImage.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    init(
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url] {
            let _ = print("cached \(url.absoluteString)")
            content(.success(cached))
        } else {
            let _ = print("request \(url.absoluteString)")
            
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction) { phase in
                    cacheAndRender(phase: phase)
                }
        }
    }
    
    /// This will cache the image coming from server and returns the content
    /// - Parameter phase: AsyncImagePhase
    /// - Returns: Content of a image
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url] = image
        }
        
        return content(phase)
    }
}

#Preview {
    CacheAsyncImage(
        url: URL(string: "https://apod.nasa.gov/apod/image/2405/STScI-WASP43b_temperature.png")!
    ) { phase in
        switch phase {
        case .empty:
            ProgressView()
        case .success(let image):
            image
        case .failure(_):
            Image(systemName: "questionmark")
        @unknown default:
            fatalError()
        }
    }
}

/// Cache Image Class responsible for having a cache
class ImageCache {
    static private var cache: [URL: Image] = [:]

    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}


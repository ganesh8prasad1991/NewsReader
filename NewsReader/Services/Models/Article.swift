//
//  Article.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import Foundation

struct Article: Codable, Identifiable {
    var id: UUID { UUID() }
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: URL?
    let publishedAt: String?
    let content: String?
}

struct Source: Codable {
    let id: String?
    let name: String?
}

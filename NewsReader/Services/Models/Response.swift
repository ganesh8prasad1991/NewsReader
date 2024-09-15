//
//  Response.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import Foundation

struct ArticleResponse: Codable {
    let status: String
    let code: String?
    let message: String?
    
    let totalResults: Int?
    var articles: [Article]? = []
}

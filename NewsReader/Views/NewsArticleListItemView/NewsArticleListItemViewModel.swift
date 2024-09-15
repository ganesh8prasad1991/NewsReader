//
//  NewsArticleListItemViewModel.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 15/09/24.
//

import Foundation

@Observable
final class NewsArticleListItemViewModel {
    let article: Article
    var isBookmark: Bool
    private let stack: LocalDataBaseStackProtocol
    
    init(
        article: Article,
        isBookmark: Bool = false,
        stack: LocalDataBaseStackProtocol = CoreDataStack.shared
    ) {
        self.article = article
        self.isBookmark = isBookmark
        self.stack = stack
    }
    
    func createBookmark() async {
        let result = await stack.saveArticle(article)
        isBookmark = result
    }
}

//
//  CDArticle+CoreDataProperties.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 15/09/24.
//
//

import Foundation
import CoreData


extension CDArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDArticle> {
        return NSFetchRequest<CDArticle>(entityName: "CDArticle")
    }
    
    @nonobjc public class func deleteRequest() -> NSBatchDeleteRequest {
        return NSBatchDeleteRequest(fetchRequest: fetchRequest())
    }

    @NSManaged public var id: UUID?
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var articleDescription: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var content: String?

}

extension CDArticle : Identifiable {
    func makeArticle() -> Article {
        Article(
            source: nil,
            author: author,
            title: title,
            description: articleDescription,
            urlToImage: URL(string: urlToImage ?? ""),
            publishedAt: publishedAt,
            content: content
        )
    }
}

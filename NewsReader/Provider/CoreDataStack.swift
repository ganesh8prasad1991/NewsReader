//
//  CoreDataStack.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 15/09/24.
//

import CoreData

protocol LocalDataBaseStackProtocol {
    func saveArticle(_ article: Article) async -> Bool
    func fetchArticles() async -> [Article]
    func deleteArticle(article: Article) async
}

actor CoreDataStack {
    // MARK: Properties
    static let shared = CoreDataStack()
    private let persistentContainerName = "NewsReader"
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: INIT
    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: persistentContainerName)
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: PRIVATE FUNC OF COREDATA
    private func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error saving context: \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) -> [T] {
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    private func delete(_ request: NSBatchDeleteRequest) {
        do {
            try viewContext.execute(request)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: LocalDataBaseStackProtocol METHODS
extension CoreDataStack: LocalDataBaseStackProtocol {
    func saveArticle(_ article: Article) async  -> Bool{
        let context = viewContext
        await context.perform {
            let cdArticle = CDArticle(context: context)
            cdArticle.id = UUID()
            cdArticle.author = article.author
            cdArticle.title = article.title
            cdArticle.articleDescription = article.description
            cdArticle.urlToImage = article.urlToImage?.absoluteString
            cdArticle.publishedAt = article.publishedAt
            cdArticle.content = article.content
        }
        
        self.saveContext()
        return true
    }
    
    func fetchArticles() async -> [Article] {
        let cdArticles = fetch(CDArticle.fetchRequest())
        return cdArticles.map {
            $0.makeArticle()
        }
    }
    
    func deleteArticle(article: Article) async {
        delete(CDArticle.deleteRequest())
    }
}


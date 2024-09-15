//
//  BookmarkViewModel.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 15/09/24.
//

import Foundation

@Observable
final class BookmarkViewModel {
    // MARK: PROPERTIES
    var bookmarks = [Article]()
    var isLoaded: Bool = false
    var showAlert: Bool = false
    var message: String = ""
    
    private let localStack: LocalDataBaseStackProtocol
    
    // MARK: INIT
    init(localStack: LocalDataBaseStackProtocol = CoreDataStack.shared) {
        self.localStack = localStack
    }
    
    func getBookmarkArticles() async {
        defer {
            if !bookmarks.isEmpty {
                updateData(
                    isLoaded: true,
                    showAlert: false
                )
            }
        }
        
        do {
            bookmarks = await localStack.fetchArticles()
        }
    }
    
    private func updateData(
        isLoaded: Bool,
        showAlert: Bool,
        message: String = ""
    ) {
        self.isLoaded = isLoaded
        self.showAlert = showAlert
        self.message = message
    }
}


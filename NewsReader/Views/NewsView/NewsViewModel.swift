//
//  NewsViewModel.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import Foundation

@Observable
final class NewsViewModel {
    // MARK: PROPERTIES
    var articles = [Article]()
    var categories = [CategoryModel]()
    var isLoaded: Bool = false
    var showAlert: Bool = false
    var message: String = ""
    
    private let apiService: APIServiceProtocol
    
    // MARK: INIT
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        self.categories = Category.allCases.map {
            CategoryModel(category: $0, isSelected: false)
        }
    }
    
    func getArticles() async throws {
        defer {
            if !articles.isEmpty {
                updateData(
                    isLoaded: true,
                    showAlert: false
                )
            }
        }
        
        do {
            articles = try await apiService.fetchNews(category: .everything)
        } catch {
            articles = []
            updateData(
                isLoaded: true,
                showAlert: true,
                message: error.localizedDescription
            )
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

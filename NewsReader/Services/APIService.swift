//
//  APIService.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import Foundation

enum APIError: Error {
    case urlInitializationError
    case urlRequestInitializationError
    case responseError
}

struct Constants {
    static let apiKey = "397644471b2149e190ba613ffae6c2b1"
    static let scheme = "https"
    static let host = "newsapi.org"
    static let path = "/v2/top-headlines"
}

protocol APIServiceProtocol {
    func fetchNews(category: Category) async throws -> [Article]
}

final class APIService: APIServiceProtocol {
    // MARK: - Initializer
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
        
    func get<T: Decodable>(
        to endPoint: EndPoint
    ) async throws -> T {
        do {
            // 1. validate URLRequest
            let urlRequest = try endPoint.makeRequest()
            // 2. API call
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            // Print Logs
            debugPrint("\n🤖 API Call Details")
            debugPrint("URLRequest: \(urlRequest)")
            
            // 2. Error Handling
            if let response = response as? HTTPURLResponse {
                debugPrint("Response Status: \(response.statusCode)")
                
                if response.statusCode != 200 {
                    throw APIError.responseError
                }
            }
            // 3. Decode
            let result = try JSONDecoder().decode(T.self, from: data)
            // Print response data, if any
            let string = String(
                data: data,
                encoding: .utf8
            ) ?? "NULL"
            debugPrint("Response(raw): \(string)")
            
            debugPrint("API FINISHED 🤖\n")
    
            return result
        } catch {
            throw error
        }
    }
    
    func fetchNews(category: Category) async throws -> [Article] {
        let endPoint = EndPoint(category: category)
        let response: ArticleResponse = try await get(to: endPoint)
        return response.articles ?? []
    }
}



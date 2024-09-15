//
//  EndPoint.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 14/09/24.
//

import Foundation

enum Category: String {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
    case everything
}

struct EndPoint {
    let category: Category
}

extension EndPoint {
    func makeRequest() throws -> URLRequest {
        
        // 1. make URLComponents
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path
        
        // 2. add query parameters
        var queryItems = [
            URLQueryItem(name: "apiKey", value: Constants.apiKey),
            URLQueryItem(name: "country", value: "us")
        ]
        
        if category != .everything {
            queryItems.append(
                URLQueryItem(name: "category", value: category.rawValue)
            )
        }
        
        components.queryItems = components.queryItems.map {
            $0 + queryItems } ?? queryItems
        
        // If either the path or the query items passed contained
        // invalid characters, we'll get a nil URL back:
        guard let url = components.url else {
            throw APIError.urlRequestInitializationError
        }
        
        // 3. return URLRequest
        return URLRequest(url: url)
    }
}


//
//  APIServiceTests.swift
//  NewsReaderTests
//
//  Created by Ganesh Prasad on 14/09/24.
//

import XCTest
@testable import NewsReader

final class APIServiceTests: XCTestCase {
        
    func sut(with fileName: String, statusCode: Int) throws -> APIServiceProtocol {
        let url = URL(string:  Constants.scheme + "://" + Constants.host)
        let data = try JSONFileLoader(
            bundle: .init(for: type(of: self))
        ).load(fileName)
        
        let response = HTTPURLResponse(
            url: url!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        URLProtocolMock.mockURLs = [url: (nil, data, response)]
        
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [URLProtocolMock.self]
        let mockSession = URLSession(configuration: sessionConfiguration)
        return APIService(urlSession: mockSession)
    }
    
    func testFailureResponse() async throws {
        do {
            let apiService = try sut(
                with: "NewsResponse",
                statusCode: 201
            )
            let news = try await apiService.fetchNews(category: .business)
            XCTAssertEqual(news.count, 1)
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.responseError)
        }
    }
    
    func testSuccessResponse() async throws {
        do {
            let apiService = try sut(with: "NewsResponse", statusCode: 200)
            let news = try await apiService.fetchNews(category: .everything)
            XCTAssertEqual(news.count, 1)
        } catch let error {
            XCTAssertThrowsError(error)
        }
    }
}

/// Mock File
final class URLProtocolMock: URLProtocol {
    /// Dictionary maps URLs to tuples of error, data, and response
    static var mockURLs = [URL?: (error: Error?, data: Data?, response: HTTPURLResponse?)]()

    override class func canInit(with request: URLRequest) -> Bool {
        // Handle all types of requests
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Required to be implemented here. Just return what is passed
        return request
    }

    override func startLoading() {
        if let url = request.url?.host() {
            if let (error, data, response) = URLProtocolMock.mockURLs[URL(string: "https://" + url)] {
                
                if let response {
                    self.client?.urlProtocol(
                        self,
                        didReceive: response,
                        cacheStoragePolicy: .notAllowed
                    )
                }
                
                if let data {
                    self.client?.urlProtocol(
                        self,
                        didLoad: data
                    )
                }
                
                if let error {
                    self.client?.urlProtocol(
                        self,
                        didFailWithError: error
                    )
                }
            }
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

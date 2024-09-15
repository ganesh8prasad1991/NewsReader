//
//  EndPointTests.swift
//  NewsReaderTests
//
//  Created by Ganesh Prasad on 14/09/24.
//

import XCTest
@testable import NewsReader

final class EndPointTests: XCTestCase {

    func testGeneratingURLRequestWithpath() throws {
        let endpoint = EndPoint(category: .everything)
        
        let request = try endpoint.makeRequest()
        let pathExtension = try XCTUnwrap(request.url?.path)
        XCTAssertEqual(
            pathExtension,
            "/v2/top-headlines"
        )
        
        XCTAssertEqual(
            request.url?.scheme,
            Constants.scheme
        )
        
        XCTAssertEqual(
            request.url?.host(),
            Constants.host
        )
    }
    
    func testGeneratingURLRequestWithQueryParameters() throws {
        let endpoint = EndPoint(category: .everything)
        
        let request = try endpoint.makeRequest()
        let url = try XCTUnwrap(request.url)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        // test for apiKey
        XCTAssertEqual(
            components?.queryItems?.first?.name,
            "apiKey"
        )
        
        XCTAssertEqual(
            components?.queryItems?.first?.value,
            Constants.apiKey
        )
        
        // country
        XCTAssertEqual(
            components?.queryItems?.last?.name,
            "country"
        )
        
        XCTAssertEqual(
            components?.queryItems?.last?.value,
            "us"
        )
    }

}

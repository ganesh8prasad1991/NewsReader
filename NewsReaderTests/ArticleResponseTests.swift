//
//  ArticleResponseTests.swift
//  NewsReaderTests
//
//  Created by Ganesh Prasad on 14/09/24.
//

import XCTest
@testable import NewsReader

final class ArticleResponseTests: XCTestCase {

    func testArticleResponseWithNegativeScenario() throws {
        let data = try sut(with: "NewsFailureResponse")
        let response = try XCTUnwrap(try JSONDecoder().decode(ArticleResponse.self, from: data))
        XCTAssertTrue(response.code == "apiKeyMissing")
    }
    
    func sut(with fileName: String) throws -> Data {
        return try JSONFileLoader(
            bundle: .init(for: type(of: self))
        ).load(fileName)
    }
}

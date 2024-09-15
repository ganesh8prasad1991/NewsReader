//
//  CacheAsyncImageTests.swift
//  NewsReaderTests
//
//  Created by Ganesh Prasad on 14/09/24.
//

import XCTest
import SwiftUI
@testable import NewsReader

final class CacheAsyncImageTests: XCTestCase {
    private let url = URL(string: "https://www.google.com")
    
    override func setUpWithError() throws {
        let unWrapURL = try XCTUnwrap(url)
        ImageCache[unWrapURL] = nil
    }
    
    func testCacheAsyncImageWhenCached() throws {
        let expectation = XCTestExpectation(description: "CACHEASYNCIMAGE")
        let unWrapURL = try XCTUnwrap(url)
        ImageCache[unWrapURL] = Image(systemName: "doc.richtext.fill")
        
        let _ = CacheAsyncImage(
            url: unWrapURL
        ) { phase in
            if case .success(let image) = phase {
                XCTAssertNotNil(image)
                XCTAssertEqual(image, ImageCache[unWrapURL])
                expectation.fulfill()
            }
            
            return EmptyView()
        }.body
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testCacheAndRenderImageWithCaching() throws {
        let unWrapURL = try XCTUnwrap(url)
        let cacheAsyncImage = CacheAsyncImage(
            url: unWrapURL
        ) { phase in
            debugPrint(phase)
            return EmptyView()
        }
        
        let _ = cacheAsyncImage.cacheAndRender(
            phase: .success(Image(systemName: "doc.richtext.fill"))
        )
        XCTAssertNotNil(ImageCache[unWrapURL])
    }
    
    func testCacheAndRenderImageWithNoCaching() throws {
        let unWrapURL = try XCTUnwrap(url)
        let cacheAsyncImage = CacheAsyncImage(
            url: unWrapURL
        ) { phase in
            debugPrint(phase)
            return EmptyView()
        }
        
        let _ = cacheAsyncImage.cacheAndRender(
            phase: .failure(APIError.urlInitializationError)
        )
        XCTAssertNil(ImageCache[unWrapURL])
    }
}

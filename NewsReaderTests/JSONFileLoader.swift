//
//  JSONFileLoader.swift
//  NewsReaderTests
//
//  Created by Ganesh Prasad on 14/09/24.
//

import Foundation

final class JSONFileLoader {
    let bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    enum JSONLoaderError: Error {
        case fileNotFound(name: String)
        case fileLoadingFailed(name: String, error: Error)
        case fileDecodingFailed(name: String, error: Error)
    }
    
    func load(_ fileName: String) throws -> Data {
        let data: Data
        
        guard let file = bundle.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            throw JSONLoaderError.fileNotFound(name: fileName)
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            throw JSONLoaderError.fileLoadingFailed(name: fileName, error: error)
        }
        
        return data
    }
}


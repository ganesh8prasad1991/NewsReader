//
//  CategoryModel.swift
//  NewsReader
//
//  Created by Ganesh Prasad on 15/09/24.
//

import Foundation

struct CategoryModel: Identifiable {
    var id = UUID().uuidString
    let category: Category
    var isSelected: Bool
}

//
//  Product.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import Foundation

// MARK: - Product
struct Product: Codable {
    let id: Int
    let title: String
    let price: Int
    let description: String
    let category: Category
    let images: [String]
    var quantity: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.price = try container.decode(Int.self, forKey: .price)
        self.description = try container.decode(String.self, forKey: .description)
        self.category = try container.decode(Category.self, forKey: .category)
        self.images = try container.decode([String].self, forKey: .images)
        self.quantity = AppConstants.defaultStockAmount
    }
}



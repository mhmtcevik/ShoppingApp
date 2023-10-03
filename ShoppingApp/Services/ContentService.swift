//
//  ContentService.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 1.10.2023.
//

import Foundation

protocol IContentService {
    var products: [Product] { get set }
    var basketItems: [Int] { get set }
    var categories: [Category] { get set }
}

class ContentService: IContentService {
    static let shared = ContentService()
    
    private init() {}
    
    var products: [Product] = []
    var basketItems: [Int] = []
    var categories: [Category] = []
}
